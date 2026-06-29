-- Remove ordering from permissions (module ordering is retained).

ALTER TABLE permissions
    DROP COLUMN IF EXISTS ordering;
