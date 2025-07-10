-- create a temp copy 
CREATE TEMP TABLE old_feedbacks AS
SELECT * FROM feedback;

-- call the procedure
CALL delete_old_feedbacks_and_count(NULL);

-- check deleted lines
SELECT * FROM old_feedbacks
WHERE feedbackid NOT IN (SELECT feedbackid FROM feedback);
