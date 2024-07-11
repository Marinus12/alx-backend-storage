-- Ensure we are using the correct database
USE holberton;

-- Create the index on the first letter of the name and the score
CREATE INDEX idx_name_first_score ON names (LEFT(name, 1), score);
