# ===================================================================================
# How to Integrate a Dimension table. In other words, how to look-up Foreign Key
# values FROM a dimension table and add them to new Fact table columns.
#
# First, go to Edit -> Preferences -> SQL Editor and disable 'Safe Edits'.
# Close SQL Workbench and Reconnect to the Server Instance.
# ===================================================================================

USE sakila_dw2;

# ==============================================================
# Step 1: Add New Column(s)
# ==============================================================
ALTER TABLE sakila_dw2.fact_inventory
ADD COLUMN inventory_date_key int NOT NULL AFTER last_update;

# ==============================================================
# Step 2: Update New Column(s) with value from Dimension table
#         WHERE Business Keys in both tables match.
# ==============================================================
UPDATE sakila_dw2.fact_inventory AS fi
JOIN sakila_dw2.dim_date AS dd
ON DATE(fi.last_update) = dd.full_date
SET fi.inventory_date_key = dd.date_key;

# ==============================================================
# Step 3: Validate that newly updated columns contain valid data
# ==============================================================
SELECT last_update
	, inventory_date_key
FROM sakila_dw2.fact_inventory
LIMIT 10;

# =============================================================
# Step 4: If values are correct then drop old column(s)
# =============================================================
ALTER TABLE sakila_dw2.fact_inventory
DROP COLUMN last_update;

# =============================================================
# Step 5: Validate Finished Fact Table.
# =============================================================
SELECT * FROM sakila_dw2.fact_inventory
LIMIT 10;
