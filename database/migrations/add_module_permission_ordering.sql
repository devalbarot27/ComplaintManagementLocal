-- Add display ordering for modules.

ALTER TABLE modules
    ADD COLUMN IF NOT EXISTS ordering INTEGER NOT NULL DEFAULT 0;

UPDATE modules
SET ordering = id
WHERE ordering = 0;
