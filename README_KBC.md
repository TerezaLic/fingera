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

Columns:
* accept_manual_cause_selection (boolean) – defaults to true, controls if terminal accepts
custom selection of action (when set to false, actions are processed automatically or
according to is_present_cause_id and not_present_cause_id settings)
* assigned_terminal_id (integer) – id of other terminal (paired with same station), that shows
identification result messages and controls doors opening
* doors_opening_time (integer) – specifies time in seconds, during which door lock is open
* extended_setting_id (integer) – when is_extended_setting == true, this value contain id of
“real” terminal, to which extended settings apply
* extended_setting_type (integer) – controls if extended settings are configured for
individual users or whole groups of users, possible values:
* external_switch_doors_opening_time (integer) – when terminal's door lock function can
be controlled by external switch, this value specifies how many seconds is door lock open
* fingera_station_id (integer) – id of station that terminal is paired with, equals to NULL for
extended settings
* icons_count (integer) – specifies number and layout of icons (actions) on terminal's screen,
available and applied only for android terminals (possible values are 6 or 9)
* ip_address (string) – IP address of terminal in local network with server (equals 127.0.0.1
for standalone terminals)
* is_extended_setting (boolean) - “real” (physical) terminals have this set to false, when set
to true, this terminal record is used for special behaviour of terminal with id ==
extended_setting_id and following settings can be customized for specified users or groups:
accept_manual_cause_selection, is_present_cause_id , not_present_cause_id ,
show_identification_result_on_terminal , play_sound , open_doors ,
open_doors_on_arrivals , open_doors_on_departures , open_doors_on_passes and
doors_opening_time
* is_present_cause_id (integer) – id of action to be executed when user is in present state,
default to 0 - Automatically (see causes_list column from local_settings for more details)
* mac_address (string) – if available, contains actual mac address of terminal
* name (string) – name of terminal
* not_present_cause_id (integer) – similar to is_present_cause_id, but applies when user is
not present
* open_doors (boolean) – controls if terminal open doors (activates relay); when set to false,
none of open_doors_on_arrivals , open_doors_on_departures , open_doors_on_passes
apply
* open_doors_on_arrivals (boolean) – controls if doors are open on arrivals
* open_doors_on_departures (boolean) – controls if doors are open on departures
* open_doors_on_passes (boolean) – controls if doors are open on passes
* play_sound (boolean) – controls if terminal uses sound messages set in local_settings
* scanner_blink_mode_id (integer) – id of scanner blink mode, in which terminal operates
(not available for android terminals)
* show_identification_result_on_terminal (boolean) – controls if identification result
message is displayed on terminal's screen
* station_id (string) – internal id of terminal, used for terminal identification on local network
* terminal_type (integer) – terminal type, possible values:
* volume (integer) – possible values are 0-7, applies only for volume level on ma300
terminals
* zk_installer_version (string) – version of software on terminal, usually in form X.Y.Z
(example: 2.0.1)

**users**

Columns:
* allow_own_web_overview (boolean) – flag if user has own web overview set up
* archived (boolean) – default to false, when user is archived, this flag is set to true
* archived_at (datetime) – time when was user archived
* authorization_group_id (integer) – randomly assigned authorization group when using
PIN and group authorization mode
* custom_link (string, 255 chars limit) – link in users summary instead of standard
status/worktime switching
* deleted (boolean) – if user is deleted from GUI, this flag is set and user is archived, and can
be restored (user is deleted from database after 90 days)
* email (string, 64 chars limit) – user logins to own web overview with email address and
password, mail is delivered to this address when own web overview is set up or changed

(and mail delivery is checked)
* first_name (string, 64 chars limit) – first name of user
* fund_medical_examination (integer) – year fund for Medical examination (id 3 in
event_categories), in days
* fund_medical_examination_family_member (integer) – year fund for Medical
examination with family member (id 8 in event_categories), in days
* fund_vacation (integer) – year fund for Vacation (id 2 in event_categories), in days
* group_id (integer) – id of group user is assigned to
* last_name (string, 64 chars limit) – last name of user
* pin (integer) – PIN stored as integer (“0123” is stored as 123)
* registration_type (integer) – specifies identification tools user has set up (card and
fingerprint, PIN is stored separately in use_pin column)
* use_pin (boolean) – flag if user's PIN is active (PIN can be saved even if its not active)

Columns for information purposes:
address, birth_number, date_of_birth, employed_since, personal_number, role

**time_logs**

Columns:
* arrival_at_station (integer) – id of fingera station where log was opened
* arrival_doors_id (integer) – currently only holds information if doors was opened or not
(doors were not opened when value is NULL)
* arrival_photo_id (integer) – id of identification photo taken when log was opened
* arrival_terminal_id (integer) – id of terminal where log was opened
* arrival_type (integer) – how was user authorized when log was opened
* day_schedule_id (integer) - information about schedule time log was created in
* deleted_manually (boolean) – defaults to false; when time log is manually deleted (or when
time log is manually edited, original version of time log is stored as manually deleted), this
flag is set to true and time log is not count in reporting (it is stored only for history archiving
purposes)
* departure_doors_id (integer) – similar to arrival_doors_id , information if doors were
opened when log was closed
* departure_from_station (integer) - id of fingera station where log closed
* departure_photo_id (integer) - id of identification photo taken when log was closed
* departure_terminal_id (integer) - id of terminal where log was closed
* departure_type (integer) - how was user authorized when log was closed, see arrival_type
for more details
* edited_manually (boolean) – defaults to false, set to true if time log was manually edited
* editor_id (integer) – id of record in user_accounts, administrator that edited or deleted this
time log
* event_category_id (integer) – id of record in event_categories table, more details in section
for that table
* finished_at (datetime) – time of log's end, can be rounded according to group's or schedule
settings
* finished_at_real (datetime) - time of log's end, original time with no rounding applied,
stored for information purposes
* late_arrival (integer) – in seconds, if late arrivals are checked, holds information about late
arrival according to group's or schedule settings
* log_duration (integer) – duration of time log in seconds (finished_at – started_at rounded
to integer), event category affects how is it counted to work time
* note (string) – manually created/edited logs can have note set
* position_in_schedule_index (integer) – information about schedule position time log was
created in
* schedule_reference_time (datetime) – day, to which log should be count (group's
counting_type settings affects this too)
- only date is important, time is 00:00:00 in local time zone
- usually it is the same day as started_at
- when using schedules, it is set according to schedule settings
- when starting break, this information is transferred from work time log, similar when
closing work time log and opening Short event or Exact long-term event
* started_at (datetime) – time of log's start, can be rounded according to group's or schedule
settings
* started_at_real (datetime) – time of log's start, original time with no rounding applied,
stored for information purposes
* started_working_at (datetime) – column used only internally for Long event or Exact long-
term event processing
* state (string) – column used internally for processing purposes
* user_id (integer) – id of user time log belongs to (only holidays have user_id == NULL)
