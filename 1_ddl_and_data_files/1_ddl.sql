CREATE TABLE cars (
    id              VARCHAR2(11) NOT NULL,
    brand           VARCHAR2(50) NOT NULL,
    production_year NUMBER(4) NOT NULL,
    model           VARCHAR2(100) NOT NULL,
    category_id   NUMBER(4) NOT NULL
);

ALTER TABLE cars ADD CONSTRAINT cars_pk PRIMARY KEY ( id );

CREATE TABLE categories (
    id            NUMBER(3) NOT NULL,
    category_name VARCHAR2(60) NOT NULL
);

ALTER TABLE categories ADD CONSTRAINT categories_pk PRIMARY KEY ( id );

CREATE TABLE customers (
    id         NUMBER(10) GENERATED ALWAYS AS IDENTITY (START WITH 1) NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    last_name  VARCHAR2(60) NOT NULL,
    email VARCHAR2(320)
);

ALTER TABLE customers ADD CONSTRAINT customers_pk PRIMARY KEY ( id );

CREATE TABLE fines (
    id          NUMBER(10) GENERATED ALWAYS AS IDENTITY (START WITH 1) NOT NULL,
    fine_date   DATE NOT NULL,
    fine_balance NUMBER(15),
    rental_id   NUMBER(38) NOT NULL,
    fine_description VARCHAR2(200) 
);

ALTER TABLE fines ADD CONSTRAINT fines_pk PRIMARY KEY ( id );

CREATE TABLE rentals (
    id             NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1) NOT NULL,
    rental_date    TIMESTAMP NOT NULL,
    rental_status  VARCHAR2(15) NOT NULL,
    car_id        VARCHAR2(11) NOT NULL,
    customer_id   NUMBER(10) NOT NULL
);

ALTER TABLE rentals ADD CONSTRAINT rentals_pk PRIMARY KEY ( id );

ALTER TABLE cars
    ADD CONSTRAINT cars_categories_fk FOREIGN KEY ( category_id )
        REFERENCES categories ( id );

ALTER TABLE fines
    ADD CONSTRAINT fines_rentals_fk FOREIGN KEY ( rental_id )
        REFERENCES rentals ( id );

ALTER TABLE rentals
    ADD CONSTRAINT rentals_cars_fk FOREIGN KEY ( car_id )
        REFERENCES cars ( id );

ALTER TABLE rentals
    ADD CONSTRAINT rentals_customers_fk FOREIGN KEY ( customer_id )
        REFERENCES customers ( id );
