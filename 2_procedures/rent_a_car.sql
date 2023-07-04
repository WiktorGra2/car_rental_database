--Auxiliary function
CREATE OR REPLACE FUNCTION get_customer_active_rentals (
    in_cust_id NUMBER
) RETURN NUMBER IS
    v_rentals_count NUMBER;
BEGIN
    SELECT
        COUNT(rental_status)
    INTO v_rentals_count
    FROM
        rentals
    WHERE
            customer_id = in_cust_id
        AND rental_status = 'active';

    RETURN v_rentals_count;
END;
/

--Auxiliary function
CREATE OR REPLACE FUNCTION get_available_cars (
    in_car_id IN VARCHAR2
) RETURN NUMBER IS
    available_cars NUMBER;
BEGIN
    SELECT
        number_owned
    INTO available_cars
    FROM
        cars
    WHERE
        id = in_car_id;

    RETURN available_cars;
END get_available_cars;
/

--Auxiliary function
CREATE OR REPLACE FUNCTION get_car_availability_date (
    in_car_id IN VARCHAR2
) RETURN TIMESTAMP IS
    return_date TIMESTAMP;
BEGIN
    SELECT
        rental_date
    INTO return_date
    FROM
        rentals
    WHERE
        car_id = in_car_id
    ORDER BY
        rental_date ASC
    FETCH FIRST ROW ONLY;

    RETURN return_date;
END get_car_availability_date;
/

--Auxiliary function
CREATE OR REPLACE FUNCTION get_unpaid_fines (
    in_cust_id NUMBER
) RETURN NUMBER IS
    v_unpaid_fines NUMBER;
BEGIN
    SELECT
        COUNT(fine_balance) AS total_fines
    INTO v_unpaid_fines
    FROM
             fines
        JOIN rentals ON fines.rental_id = rentals.id
        JOIN customers ON rentals.customer_id = customers.id
    WHERE
            fines.fine_balance < 0
        AND customers.id = in_cust_id;

    RETURN v_unpaid_fines;
END;
/

--main procedure
CREATE OR REPLACE PROCEDURE rent_a_car (
    in_car_id      IN VARCHAR2,
    in_customer_id IN NUMBER
) IS
    rental_id     NUMBER;
    v_return_date TIMESTAMP;
BEGIN
    IF get_unpaid_fines(in_customer_id) = 0 THEN
        IF get_customer_active_rentals(in_customer_id) < 3 THEN
            IF get_available_cars(in_car_id) >= 1 THEN
        -- Wstawienie nowego wypo¿yczenia do tabeli rentals
                INSERT INTO rentals (
                    car_id,
                    customer_id
                ) VALUES (
                    in_car_id,
                    in_customer_id
                ) RETURNING id INTO rental_id;
    
        -- Zmniejszenie liczby dostêpnych samochodów
                UPDATE cars
                SET
                    number_owned = number_owned - 1
                WHERE
                    id = in_car_id;

                dbms_output.put_line('Wypo¿yczono samochód o ID '
                                     || in_car_id
                                     || ' klientowi o ID '
                                     || in_customer_id
                                     || '. Numer wypo¿yczenia: '
                                     || rental_id);

            ELSIF get_available_cars(in_car_id) < 1 THEN
                v_return_date := get_car_availability_date(in_car_id);
                dbms_output.put_line('Wybrany samochód nie jest obecnie dostêpny. Najbli¿szy dostêpny termin to ' || v_return_date);
            END IF;

        ELSE
            dbms_output.put_line('Nie mo¿esz wypo¿yczyæ wiêcej ni¿ 3 samochody na raz. Aby wypo¿yczyæ kolejne, zwróæ najpierw te, które ju¿ wypo¿yczy³eœ'
            );
        END IF;

    ELSE
        dbms_output.put_line('Aby wypo¿yczyæ auto, op³aæ najpierw zaleg³e kary');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('B³¹d systemu. Powiadom administratora');
        log_errors(sqlcode, sqlerrm);
END rent_a_car;




