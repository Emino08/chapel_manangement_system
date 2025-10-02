-- Add must_change_password field to users table
-- This field indicates if a user must change their password on next login

ALTER TABLE users ADD COLUMN must_change_password TINYINT(1) DEFAULT 1 AFTER password_hash;

-- Set existing admin user to not require password change
UPDATE users SET must_change_password = 0 WHERE email = 'admin@chapel.local';
