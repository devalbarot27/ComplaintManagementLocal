-- Seed: set password to Welcome@123 for all active users in user_master.
-- Hash generated with PHP password_hash('Welcome@123', PASSWORD_DEFAULT).
-- Run: psql -U postgres -d complaint_management -f database/seeds/seed_user_passwords.sql

UPDATE user_master
SET password = '$2y$10$GUOjLYBvVDYNr4MlQlxC9urmOCV5h.web2QwqozK99VqyWr3.drGm',
    updated_at = CURRENT_TIMESTAMP
WHERE deleted_at IS NULL;
