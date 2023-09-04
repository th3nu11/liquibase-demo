# Aim

This is a simple demo to show how liquibase works. It uses docker and docker-compose, so you don't
need to install anything on your machine.

The database is a SQL Server with the following configuration:
- Database host: db
- Port: 1433
- Database name: master
- User: sa
- Password: My-Complex-Pwd-123


# Prerequisites
Docker and docker-compose installed on your machine.

# Run database
```
docker-compose up -d
```
This command will run on your machine the empty SQL Server.

## Stop database

```
docker-compose down
```

This command will remove everything.

# Liquibase

Liquibase is a tool to manage database changes. It uses a changelog file to describe the changes.
With this demo we are running a liquibase container which is connected to the database container using the same network. 
We are going to execute the liquibase commands inside the liquibase container testing different kind of changelog files. 

## Links

- [Liquibase Change Types](https://docs.liquibase.com/change-types/home.html)

## Run container liquibase
This command run a liquibase container in interactive mode. It is connected to the database container using the same network.
The flag `--rm` remove the container when you exit from it.
```
docker run -it --network=liquibase-demo-network --rm --name=liquibase -v `pwd`/liquibase.properties:/liquibase/liquibase.properties -v `pwd`/changelog:/liquibase/changelog liquibase/liquibase bash
```

## Example 1 - Create table and roll back it

This example shows how to create a table with 4 columns and a constraint for the primary key using the xml format. 
Liquibase will convert the xml file into SQL and execute it on the database.

```
liquibase --changelog-file=./changelog/001-example1.changelog.xml update
```

### Rollback
Now we want to roll back the last change. Since we used the xml format, liquibase is able to rollback the change.

```
liquibase --changelog-file=./changelog/001-example1.changelog.xml rollbackCount 1
```

## Example 2 - Big changelog

This changelog includes instead three different sub-changelog files each one with a different format type:
- xml: Creates two tables (actor1, actor2)
- yaml: Add the column `address` to the table `actor1`
- sql: Add the column `address2` to the table `actor2`

Execute

```
liquibase --changelog-file=./changelog/002-example2.changelog.xml update
```

NOTE: Since the last change is a sql file, liquibase is not able to rollback it. If you want to rollback it, you need to write the rollback sql function by yourself. 

### MD5SUM
If you try to execute again the previous command, you will see that liquibase will not execute anything.
Nevertheless, if you change the content of the sql file, and you try to execute again the previous command, liquibase will return an error.

In this way, liquibase is able to detect if the content of the file has changed. If it is the case, it will not execute the file.

There are few ways to configure liquibase behaviour:
- runOnChange:true (default false): If true, liquibase will execute the file if the content has changed.
- runAlways:true (default false): If true, liquibase will execute the file always.
- validCheckSum: In this case liquibase will consider the file as valid if the checksum is the same as the one specified in the changelog file.