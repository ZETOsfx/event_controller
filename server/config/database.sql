-- Active: 1670582240751@@127.0.0.1@5432@db_user@public

CREATE TABLE
    ec_user(
        id SERIAL PRIMARY KEY,
        name VARCHAR(255),
        role VARCHAR(255),
        passhash VARCHAR(255)
    );

CREATE TABLE
    ec_role(
        id SERIAL PRIMARY KEY,
        role VARCHAR(255)
    );

CREATE TABLE
    ec_userrole(
        user_id VARCHAR(255),
        role_id VARCHAR(255)
    );