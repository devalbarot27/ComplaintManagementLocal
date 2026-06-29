-- Add display ordering for modules and permissions (assign permission matrix).

ALTER TABLE modules
    ADD COLUMN IF NOT EXISTS ordering INTEGER NOT NULL DEFAULT 0;

ALTER TABLE permissions
    ADD COLUMN IF NOT EXISTS ordering INTEGER NOT NULL DEFAULT 0;

UPDATE modules
SET ordering = id
WHERE ordering = 0;

UPDATE permissions
SET ordering = id
WHERE ordering = 0;
