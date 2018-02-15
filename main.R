
#Install the libraries
suppressMessages(library(doParallel))

library(httr, warn.conflicts=FALSE, quietly=TRUE)
library(data.table, warn.conflicts=FALSE, quietly=TRUE)
library(xml2, warn.conflicts=FALSE, quietly=TRUE)
library(purrr, warn.conflicts=FALSE, quietly=TRUE)
library(doParallel, warn.conflicts=FALSE, quietly=TRUE)
library(dplyr, warn.conflicts=FALSE, quietly=TRUE)
library(jsonlite, warn.conflicts=FALSE, quietly=TRUE)
library(lubridate, warn.conflicts=FALSE, quietly=TRUE)
library(foreach, warn.conflicts=FALSE, quietly=TRUE)

library('keboola.r.docker.application', warn.conflicts=FALSE, quietly=TRUE)

#=======BASIC INFO ABOUT THE Fingera EXTRACTOR========#

# Using fingera API documentation v.5.4.0.
# Main Changes are defining offsets for users

#=======CONFIGURATION========#
app <- keboola.r.docker.application::DockerApplication$new('/data/')
app$readConfig()


# access the supplied value of 'myParameter'
password<-app$getParameters()$`#password`
user<-app$getParameters()$user
days<-app$getParameters()$days
start_date<-Sys.Date()-days
end_date<-Sys.Date()

# devel -------------------------------------------------------------------
api<-"http://kosik.fingera.com/api/"

endpoint<-"day_schedules"
url<-paste0(api,endpoint)

##Catch config errors

if(is.null(user)) stop("enter your username in the user config field")
if(is.null(password)) stop("enter your password in the #password config field")
if(is.null(api)) stop("no API url")

## List of possible endpoints
endpoint_list<-c(
  "day_schedules", 
  "event_categories",
  #"fingera_stations",
  "groups",
  #"local_settings",
  #"settings",
  "terminals",
  #"time_logs",
  #"user_accounts",
  "users")

##Get timelogs for one fucking day

get_timelog_day<-function(...){
  user_attr<-list(...)
  
  user_id<-user_attr[[1]]
  from<-if_else(as_date(user_attr[[2]])<start_date,start_date,as_date(user_attr[[2]]))
  
  to<-if_else(is.na(user_attr[[3]]) | user_attr[[3]]<from ,Sys.Date(),as_date(user_attr[[3]]))
  url <- paste0(api, "time_logs")
  
  from_dates<- seq(from, to,30)
  to_dates<-c(seq(from, to,30)[-1]-1,to)
  
  
  result<-map2_df(from_dates,to_dates,
                  function(x,y){
                    r <-
                      RETRY(
                        "GET",
                        url,
                        config = authenticate(user, password),
                        query = list("user_id" = user_id, "start_date"=format(x,"%d.%m.%Y"),"end_date"=format(y,"%d.%m.%Y")),
                        times = 3,
                        pause_base = 3,
                        pause_cap = 10
                      )
                    
                    res <- content(r, "text", encoding = "UTF-8") %>% fromJSON 
                    
                  }
  )
  result
}


##Functions 

getStats <- function(endpoint, api) {
  url <- paste0(api, endpoint)
  
  r <-
    RETRY(
      "GET",
      url,
      config = authenticate(user, password),
      times = 3,
      pause_base = 3,
      pause_cap = 10
    )
  
  if (as.numeric(r$headers$`x-total`) > as.numeric(r$headers$`x-max-limit`)) {
    #get the size of the list
    size <- as.numeric(r$headers$`x-total`)
    limit <- as.numeric(r$headers$`x-max-limit`)
    sequence <- seq(0, size, by = limit)
    
    #register cores on the machine for the parallel loop 
    #if(length(sequence)>1000) registerDoParallel(cores=detectCores()-1)
    
    res <-
      foreach(
        i = sequence,
        .combine = bind_rows,
        .multicombine = TRUE,
        .init = NULL,
        .errorhandling = "stop"
      ) %do% {
        
        r <-
          RETRY(
            "GET",
            url,
            config = authenticate(user, password),
            query = list("offset" = i, "limit" = limit),
            times = 3,
            pause_base = 3,
            pause_cap = 10
          )
        res <- content(r, "text", encoding = "UTF-8") %>% fromJSON
        
      }
    
  } else{ 
    res <- content(r, "text", encoding = "UTF-8") %>% fromJSON }
  
  result<-res%>%distinct
  
}


system.time(
  results<-map(endpoint_list,getStats,api=api)
)

names(results)<-endpoint_list


##Write the tables in the output bucket
sink("msgs")
map2(results,endpoint_list,function(x,y){fwrite(x,paste0("/data/out/tables/",y,".csv"))})
sing(Null)

# write table metadata - set new primary key 
endpoint_PK<-endpoint_list[endpoint_list != "terminals"]
TableManifest<-lapply(endpoint_PK,function(y){
        csvFileName<-paste("/data/out/tables/",y,".csv",sep = "")
        app$writeTableManifest(csvFileName,destination='' ,primaryKey =c('id'))})

#time logs

# tady si vytahuju seznam uživatelů a čas kdy byli vytvořeni a kdy byli archivováni. 
users<-results$users%>%select(id,created_at,archived_at)%>%
  mutate(created_at=as_date(created_at),archived_at=as_date(archived_at))

# Dvojita smyčka nad uživateli. 
time_logs_2<-pmap_df(users,get_timelog_day)

#retrieved_users<-time_logs_2%>%select(user_id)%>%rename(id=user_id)%>%distinct
#all_users<-results$users%>%select(id)%>%distinct


# Kontrola integrity 
#missing_users<-setdiff(all_users,retrieved_users)

#fwrite(missing_users,"missing_users_logs.csv")

#if(dim(missing_users)[1]>1){missing_logs<-getTimeLogs(missing_users$id, api)}

fwrite(time_logs_2,"/data/out/tables/time_logs_2.csv")
app$writeTableManifest("/data/out/tables/time_logs_2.csv",destination='' ,primaryKey =c('id'))
