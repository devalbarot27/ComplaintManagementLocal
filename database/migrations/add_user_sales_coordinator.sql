-- Assign one Sales Coordinator to Dealer User / Dealer Engineer / ELGi Engineer accounts.

ALTER TABLE user_master
    ADD COLUMN IF NOT EXISTS sales_coordinator_id INTEGER NULL;

CREATE INDEX IF NOT EXISTS idx_user_master_sales_coordinator_id
    ON user_master (sales_coordinator_id)
    WHERE sales_coordinator_id IS NOT NULL;
