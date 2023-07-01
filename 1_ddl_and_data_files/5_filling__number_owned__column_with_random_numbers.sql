ALTER TABLE CARS ADD number_owned NUMBER;

DECLARE
  v_min_value NUMBER := 1;
  v_max_value NUMBER := 10;
BEGIN
  FOR r IN (SELECT rowid, number_owned FROM cars) 
  LOOP
    UPDATE cars
    SET number_owned = FLOOR(DBMS_RANDOM.VALUE(v_min_value, v_max_value + 1))
    WHERE rowid = r.rowid;
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('Random numbers between ' || v_min_value || ' and ' || v_max_value || ' inserted successfully.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/