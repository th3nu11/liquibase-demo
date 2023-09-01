--liquibase formatted sql
--changeset ballabio:demo-2020-07-08T15:43:00.000Z splitStatements:false stripComments:false

ALTER TABLE actor2 ADD address VARCHAR(255) NULL;