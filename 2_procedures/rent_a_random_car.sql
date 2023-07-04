--auxiliary function
CREATE OR REPLACE FUNCTION get_a_random_car RETURN VARCHAR2 IS
    v_id VARCHAR2(100);
BEGIN
    SELECT
        id
    INTO v_id
    FROM
        (
            SELECT
                id
            FROM
                cars
            ORDER BY
                dbms_random.value
        )
    WHERE
        ROWNUM = 1;

    RETURN v_id;

END get_a_random_car;
/

--auxiliary function
CREATE OR REPLACE FUNCTION get_car_return_date (
    in_rental_id IN NUMBER
) RETURN TIMESTAMP IS
    return_date TIMESTAMP;
BEGIN
    SELECT
        rental_date
    INTO return_date
    FROM
        rentals
    WHERE
        id = in_rental_id;

    RETURN return_date;
END get_car_return_date;


--main procedure
CREATE OR REPLACE PROCEDURE rent_a_random_car (
    in_customer_id IN NUMBER
) IS
    rental_id     NUMBER;
    v_return_date TIMESTAMP;
    v_car_id      VARCHAR2(20) := get_a_random_car;
BEGIN
    IF get_unpaid_fines(in_customer_id) = 0 THEN
        IF get_customer_active_rentals(in_customer_id) < 3 THEN
    --IF auto jest dost�pne. je�li nie, zwr�� nr klienta i dat� przewidywanego zwrotu
            IF get_available_cars(v_car_id) >= 1 THEN
        -- Wstawienie nowego wypo�yczenia do tabeli rentals
                INSERT INTO rentals (
                    car_id,
                    customer_id
                ) VALUES (
                    v_car_id,
                    in_customer_id
                ) RETURNING id INTO rental_id;
    
        -- Zmniejszenie liczby dost�pnych samochod�w
                UPDATE cars
                SET
                    number_owned = number_owned - 1
                WHERE
                    id = v_car_id;

                dbms_output.put_line('Wypo�yczono samoch�d o ID '
                                     || v_car_id
                                     || ' klientowi o ID '
                                     || in_customer_id
                                     || '. Numer wypo�yczenia: '
                                     || rental_id);

            ELSIF get_available_cars(v_car_id) < 1 THEN
                v_return_date := get_car_return_date(v_car_id);
                dbms_output.put_line('Wybrany samoch�d nie jest obecnie dost�pny. Najbli�szy dost�pny termin to ' || v_return_date);
            END IF;

        ELSE
            dbms_output.put_line('Nie mo�esz wypo�yczy� wi�cej ni� 3 samochody na raz. Aby wypo�yczy� kolejne, zwr�� najpierw te, kt�re ju� wypo�yczy�e�'
            );
        END IF;

    ELSE
        dbms_output.put_line('Aby wypo�yczy� auto, op�a� najpierw zaleg�e kary');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('B��d systemu. Powiadom administratora');
        log_errors(sqlcode, sqlerrm);
END rent_a_random_car;



