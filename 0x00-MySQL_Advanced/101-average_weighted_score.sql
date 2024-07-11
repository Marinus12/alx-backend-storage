-- Stored Procedure to compute and store average weighted score for all users
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE current_user_id INT;
    DECLARE cur CURSOR FOR SELECT id FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO current_user_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calculate the total weight and weighted sum for the current user's scores
        DECLARE total_weight INT DEFAULT 0;
        DECLARE weighted_sum FLOAT DEFAULT 0;
        DECLARE avg_weighted_score FLOAT DEFAULT 0;

        SELECT SUM(p.weight), SUM(c.score * p.weight)
        INTO total_weight, weighted_sum
        FROM corrections c
        JOIN projects p ON c.project_id = p.id
        WHERE c.user_id = current_user_id;

        -- Calculate the average weighted score
        IF total_weight > 0 THEN
            SET avg_weighted_score = weighted_sum / total_weight;
        ELSE
            SET avg_weighted_score = 0;
        END IF;

        -- Update the user's average score in the users table
        UPDATE users
        SET average_score = avg_weighted_score
        WHERE id = current_user_id;

    END LOOP;

    CLOSE cur;
END //

DELIMITER ;
