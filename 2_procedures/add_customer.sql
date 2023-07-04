CREATE OR REPLACE PROCEDURE add_customer_with_email (
    in_first_name IN VARCHAR2,
    in_last_name  IN VARCHAR2,
    in_email      IN VARCHAR2
) IS
BEGIN
    INSERT INTO customers(first_name, last_name, email) 
    VALUES(in_first_name, in_last_name, in_email);
END add_customer_with_email;

CREATE OR REPLACE PROCEDURE add_customer (
    in_first_name IN VARCHAR2,
    in_last_name  IN VARCHAR2
) IS
BEGIN
    INSERT INTO customers(first_name, last_name) 
    VALUES(in_first_name, in_last_name);
END add_customer;
