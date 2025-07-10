-- Trigger function
CREATE OR REPLACE FUNCTION check_creator_active()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM content_creator 
        WHERE creatorid = NEW.creatorid AND isactive = TRUE
    ) THEN
        RAISE EXCEPTION 'Cannot add contract: Creator ID % is not active.', NEW.creatorid;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger binding
CREATE TRIGGER trg_check_creator_active
BEFORE INSERT ON contract
FOR EACH ROW
EXECUTE FUNCTION check_creator_active();
