# Arbyte_analysis_snwflke


Here’s a README file that you can include in your GitHub repository:

---

# Arbyte Analysis with Snowflake

This project demonstrates an ETL pipeline using Docker, PostgreSQL, Airbyte, and Snowflake. The pipeline is designed to extract data from PostgreSQL and load it into Snowflake using Airbyte for real-time synchronization.

## Project Overview

### Key Components:
- **Docker**: Used to create and manage PostgreSQL containers.
- **PostgreSQL**: Serves as the source database where data is stored.
- **Snowflake**: A cloud-based data warehousing platform where the data is ultimately stored.
- **Airbyte**: An open-source data integration platform used to transfer data from PostgreSQL to Snowflake.

## Setup Instructions

### Step 1: Clone the Repositories

First, clone the main project repository:

```bash
git clone https://github.com/Bunnydavid27/Arbyte_analysis_snwflke.git
```

If you also need Airbyte for data transfer, clone the Airbyte repository as well:

```bash
git clone https://github.com/airbytehq/airbyte.git
```

### Step 2: Set Up PostgreSQL with Docker

To set up PostgreSQL, Docker is used to create and manage the necessary containers.

1. **Create the Docker Compose file**: You should have a `Postgress_dckr.yml` file that defines your PostgreSQL service.

```yml
version: '3.1'

services:
  postgres:
    image: postgres:latest
    container_name: postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: admin
    ports:
      - "5432:5432"
    volumes:
      - dbdata:/var/lib/postgresql/data

volumes:
  dbdata:
```

2. **Run the Docker Compose command**: This command creates and runs the PostgreSQL container defined in your `Postgress_dckr.yml` file.

```bash
docker-compose -f Postgress_dckr.yml up -d
```

### Step 3: Interact with the PostgreSQL Container

1. **Access the PostgreSQL container**: Once the Docker container is running, you can manage it through the Docker Desktop application. Look for the container under "Containers/Apps," click on the dropdown arrow next to the container name, then click on the application, followed by "Exec" and "Open Terminal."

2. **Log in to PostgreSQL**: Once the terminal opens, log in to PostgreSQL using the following command:

```bash
psql -U postgres
```

3. **List the Databases**: Use the `\l` command to list all the databases.

```sql
\l
```

4. **Create a Database**: Create a database named `airbyte` in PostgreSQL.

```sql
CREATE DATABASE airbyte;
```

5. **Connect to the Database**: Use the `\c` command to switch to the `airbyte` database.

```sql
\c airbyte
```

### Step 4: Set Up Snowflake

In Snowflake, you'll need to create the necessary roles, users, warehouses, databases, and schemas to store data. Here's a brief overview of the SQL script:

```sql
set airbyte_role = 'AIRBYTE_ROLE';
set airbyte_username = 'AIRBYTE_USER';
set airbyte_warehouse = 'AIRBYTE_WAREHOUSE';
set airbyte_database = 'AIRBYTE_DATABASE';
set airbyte_schema = 'AIRBYTE_SCHEMA';
set airbyte_password = 'airbyte@123';

--- Create airbyte role
use role securityadmin;
create role if not exists identifier($airbyte_role);
grant role identifier($airbyte_role) to role sysadmin;

--- Create airbyte user 
create user if not exists identifier($airbyte_username)
password = $airbyte_password
default_role = $airbyte_role
default_warehouse = $airbyte_warehouse;
grant role identifier($airbyte_role) to user identifier($airbyte_username);
use role sysadmin;

--- Create airbyte warehouse
create warehouse if not exists identifier($airbyte_warehouse)
warehouse_size = xsmall
warehouse_type = standard
auto_suspend = 60
auto_resume = true
initially_suspended = true;

--- Create airbyte database 
create database if not exists identifier($airbyte_database);

--- Grant airbyte warehouse access
grant USAGE
on warehouse identifier($airbyte_warehouse)
to role identifier($airbyte_role);

--- Grant airbyte database access 
grant OWNERSHIP
on database identifier($airbyte_database)
to role identifier($airbyte_role);

commit;

begin; 

USE DATABASE identifier($airbyte_database);

--- Create schema for airbyte data
create schema if not exists identifier($airbyte_schema);

GRANT ALL PRIVILEGES ON SCHEMA identifier($airbyte_schema) TO ROLE identifier($airbyte_role);
commit;

begin;
```

### Step 5: Use Airbyte to Transfer Data

Once both PostgreSQL and Snowflake are set up, use Airbyte to synchronize data between them. Follow the instructions provided in the Airbyte repository to configure the source (PostgreSQL) and destination (Snowflake).

## Contributing

Feel free to fork this project, submit issues, and make pull requests!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

This README covers all the steps discussed and provides a comprehensive guide for setting up and running the ETL pipeline.
