-- Stored Procedure to compute and store average weighted score for a user
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id INT)
BEGIN
    DECLARE total_weight INT DEFAULT 0;
    DECLARE weighted_sum FLOAT DEFAULT 0;
    DECLARE avg_weighted_score FLOAT DEFAULT 0;

    -- Calculate the total weight and weighted sum for the user's scores
    SELECT SUM(p.weight), SUM(c.score * p.weight)
    INTO total_weight, weighted_sum
    FROM corrections c
    JOIN projects p ON c.project_id = p.id
    WHERE c.user_id = user_id;

    -- Calculate the average weighted score
    IF total_weight > 0 THEN
        SET avg_weighted_score = weighted_sum / total_weight;
    ELSE
        SET avg_weighted_score = 0;
    END IF;

    -- Update the user's average score in the users table
    UPDATE users
    SET average_score = avg_weighted_score
    WHERE id = user_id;
END //

DELIMITER ;
