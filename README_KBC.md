Fingera API - for KBC
---------------------

Fingera is a next-generation access control and attendance management system, built upon industry-leading biometric technology.

Following tables are currently accessible:
* day_schedules
* event_categories
* groups
* terminals
* users
* time_logs

All tables have following columns in common:
* id (integer) - unique identificator of record
* created_at (datetime) - time of record creation
* updated_at (datetime) - time of last record update

------------------------
**day_schedules**

Example:
{"arrival_tolerance":0,"auto_dinner_break_countdown":2,"check_late_arrivals":fal
se,"colour":"red","count_short_events_from_shift_start":false,"count_short_event
s_to_shift_end":false,"created_at":"2009-02-
18T16:07:21+01:00","departure_tolerance":0,"dinner_break_duration":null,"dinner_
break_threshold":null,"id":1,"last_update_at":null,"last_update_by":null,"late_a
rrival_threshold":0,"name":"Free
day","shift_duration":0,"shift_start":0,"show_late_arrival_warning":true,"update
d_at":"2009-10-
13T12:08:04+02:00","working_period_end":0,"working_period_start":0}

**event_categories**

Columns:
* active (boolean) – defaults to true. when record is deleted, and there are time logs with
event_category_id == id, this flag is set to false instead of removing record from table, to
maintain information for existing time logs
* count (boolean) – when set to false, time logs in this category are not count in work time
* custom (boolean) – flag whether record is custom created, or predefined category
* is_exact_long_event (boolean) – when set to true, category shares behaviour of short and
long events (Exact long-term event)
* is_service_event (boolean) – when set to true, category type is Special service event
* is_short (boolean) – controls whether category type is Short event or Long event
* name (string) – name of category, names of default categories are localized in Fingera GUI
* null_category (boolean) – when set to true, category type is Empty event / Note
* show_on_oled (boolean) – when set to true, category can be manually selected on terminal
* type (string) – type of category

**groups**

Columns:
* archived (boolean) – represents state of group, archived groups are hidden in whole
application but can be revoked later
* arrival_rounding (integer) – rounding of arrival at work in minutes
* all_days_are_work_days (boolean) – defaults to false – weekend and holidays
(state_holidays_counting controls this too) are not count in time fund; if set to true, all days
are count
* auto_break_countdown_threshold (float) – threshold in hours after which is created
automatic break
* auto_break_duration (float) – duration of automatic break in hours
* auto_logout_time (integer) – time in seconds used in automatic logout feature
* auto_logout_setting (integer) – describe type of automatic logout of user
* break_auto_countdown (boolean) – controls whether automatic break countdown is used
* break_rounding (integer) – rounding of work break in minutes
* counting_type (integer) – controls how are time_logs processed in reporting, defaults to 0
* create_auto_break_on_short_events (boolean) – controls whether should create automatic
break even on short events
* create_auto_dinner_on_short_events (boolean) – controls whether should create
automatic dinner even on short events
* create_auto_dinner_on_medical_examinations (boolean) – controls whether should
create automatic dinner event during medical examination events
* daily_overtimes_threshold (integer) – threshold in minutes used for daily overtimes. When
overtime is lower than this value, then time log will be cut down so overtime will look like
zero value.
* default_duration (float) – in hours (default is 8.0), controls time fund and overtimes
calculations, holidays calculations or duration for automatically created time logs in
PrivateCategory categories
* default_rounding (integer) – default rounding of any event in minutes
* departure_rounding (integer) – rounding of departure from work in minutes
* dinner_break_duration (double) – duration of dinner break
* dinner_break_auto_countdown (boolean) – controls if countdown of dinner break is set to
automatical.
* dinner_break_threshold (float) – threshold used for dinner break in hours
* dinner_rounding (integer) – rounding of dinner break in minutes
* dinner_start (integer) – start of dinner in seconds
* is_manager_group (boolean) – flag which represents if current group is manager type of
group. Manager groups ignore real arrival or departure times, every work day is closed with
standard work time.
* late_arrivals_check (integer) – late arrivals check options
* late_arrival_threshold (integer) – threshold in seconds used to check after how many
seconds the arrival is evaluated as late
* minimal_dinner_duration (float) – minimal duration of of dinner in hours
* name (string, 64 chars limit) – name of group
* overtimes_transfer (boolean) – defaults to false, controls if overtimes transfer calculations
are active
* overtimes_type (integer) – controls which types of overtimes are calculated, defaults to 2
* reports_without_overtimes_duration (integer) – represents number of seconds of work
time per day, mainly used in reports.
* round_time_fund (boolean) – controls whether reports should show count of work days
and time fund if overtimes are hidden
* rounding_type (integer) – type of rounding
* schedule_type (integer) – type of schedule
* show_late_arrival_warning (boolean) – controls whether a warning about the late arrival
should be shown
* state_holidays_counting (integer) – defaults to 0, controls holidays calculations
* total_work_time_counting_period (integer) – period for work time counting
* total_work_time_displaying (integer) – code which represents total work time display type
* use_dinner_start_for_auto_dinners (boolean) – tells if dinner start attribute is used for
* work_days_counting (integer) – counting type of work days
* work_time_start (integer) – start of work time in seconds

**terminals**

**users**

**time_logs**
