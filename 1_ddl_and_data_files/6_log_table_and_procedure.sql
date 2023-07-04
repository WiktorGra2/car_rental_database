CREATE TABLE error_log (ts TIMESTAMP NOT NULL, sqlcode VARCHAR2(4000), sqlerrm VARCHAR2(4000));

CREATE PROCEDURE log_errors (in_sqlcode IN VARCHAR2, in_sqlerrm IN VARCHAR2) IS
BEGIN
  INSERT INTO error_log (ts, sqlcode, sqlerrm)
  VALUES (SYSTIMESTAMP, in_sqlcode, in_sqlerrm);
END log_errors;