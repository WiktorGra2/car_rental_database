--auxiliary function
CREATE OR REPLACE FUNCTION is_rental_already_completed (
    in_rental_id IN NUMBER
) RETURN VARCHAR2 IS
    v_rental_status VARCHAR2(25);
BEGIN
    SELECT
        rental_status
    INTO v_rental_status
    FROM
        rentals
    WHERE
        id = in_rental_id;

    RETURN v_rental_status;
END is_rental_already_completed;
/

CREATE OR REPLACE PROCEDURE return_car (
    in_rental_id IN NUMBER
) IS
    v_car_id  VARCHAR2(20);
    v_fine_id NUMBER;
BEGIN
    IF is_rental_already_completed(in_rental_id) = 'completed' THEN
        dbms_output.put_line('Samoch�d o tym ID zosta� ju� zwr�cony');
    ELSE
        IF get_car_return_date(in_rental_id) >= SYSDATE THEN 
        -- Ustawienie daty zwrotu i statusu wypo�yczenia
            UPDATE rentals
            SET
                rental_status = 'completed'
            WHERE
                id = in_rental_id
            RETURNING car_id INTO v_car_id;
        
        -- Zwi�kszenie liczby dost�pnych samochod�w
            UPDATE cars
            SET
                number_owned = number_owned + 1
            WHERE
                id = v_car_id;

            dbms_output.put_line('Samoch�d o ID '
                                 || v_car_id
                                 || ' zosta� zwr�cony na czas');
            COMMIT;
        ELSE
            INSERT INTO fines (
                fine_date,
                fine_balance,
                rental_id,
                fine_description
            ) VALUES (
                sysdate,
                - 500,
                in_rental_id,
                'Kara za niezwr�cenie samochodu na czas'
            ) RETURNING id INTO v_fine_id;

            dbms_output.put_line('Samoch�d o ID '
                                 || v_car_id
                                 || ' nie zosta� zwr�cony na czas');
            dbms_output.put_line('Musisz zap�aci� kar� o warto�ci xxx');
            dbms_output.put_line('Nr kary: ' || v_fine_id);
            COMMIT;
        END IF;
    END IF;
END return_car;
/




