CREATE OR REPLACE PROCEDURE delete_old_feedbacks_and_count(OUT deleted_count INT)
LANGUAGE plpgsql
AS $$
DECLARE
    feedbacks_before DATE := CURRENT_DATE - INTERVAL '5 years';
BEGIN
    -- Delete feedback that is too old
    DELETE FROM feedback
    WHERE feedbackdate < feedbacks_before;

    -- Return the number of lines deleted
    GET DIAGNOSTICS deleted_count = ROW_COUNT;

    RAISE NOTICE 'Deleted % old feedback(s).', deleted_count;
END;
$$;
