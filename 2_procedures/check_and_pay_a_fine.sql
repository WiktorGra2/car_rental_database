CREATE OR REPLACE PROCEDURE check_the_fine_amount (
    in_fine_id NUMBER
) 
IS
    v_fine_amount NUMBER;
BEGIN
    SELECT
        fine_balance
    INTO v_fine_amount
    FROM
        fines
    WHERE
        id = in_fine_id;

    dbms_output.put_line('Masz do zap³acenia: '||(-v_fine_amount));

END check_the_fine_amount;
/


CREATE OR REPLACE PROCEDURE pay_the_fine (
    in_fine_id        NUMBER,
    in_payment_amount NUMBER
) IS
BEGIN
    UPDATE fines
    SET
        fine_balance = fine_balance + in_payment_amount
    WHERE
        id = in_fine_id;

    dbms_output.put_line('Kara zosta³a op³acona');
END pay_the_fine;
/
