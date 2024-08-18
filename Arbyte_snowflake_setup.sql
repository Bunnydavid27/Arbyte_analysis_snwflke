set airbyte_role = 'AIRBYTE_ROLE';
set airbyte_username = 'AIRBYTE_USER';
set airbyte_warehouse = 'AIRBYTE_WAREHOUSE';
set airbyte_database = 'AIRBYTE_DATABASE';
set airbyte_schema = 'AIRBYTE_SCHEMA';
set airbyte_password = 'airbyte@123';


---create airbyte role
use role securityadmin;
create role if not exists identifier($airbyte_role);
grant role identifier($airbyte_role) to role sysadmin;




---create airbyte user 
create user if not exists identifier($airbyte_username)
password = $airbyte_password
default_role = $airbyte_role
default_warehouse = $airbyte_warehouse;
grant role identifier($airbyte_role) to user identifier($airbyte_username);
use role sysadmin;


---create airbyte warehouse
create warehouse if not exists identifier($airbyte_warehouse)
warehouse_size = xsmall
warehouse_type = standard
auto_suspend = 60
auto_resume = true
initially_suspended = true;


---create airbyte database 
create database if not exists identifier($airbyte_database);


---grant airbyte warehouse access
grant USAGE
on warehouse identifier($airbyte_warehouse)
to role identifier($airbyte_role);


---grant airbyte database acess 
grant OWNERSHIP
on database identifier($airbyte_database)
to role identifier($airbyte_role);

commit;

begin; 

USE DATABASE identifier($airbyte_database);

---create schema for airbyte data
create schema if not exists identifier($airbyte_schema);

GRANT ALL PRIVILEGES ON SCHEMA identifier($airbyte_schema) TO ROLE identifier($airbyte_role);
commit;

begin;

