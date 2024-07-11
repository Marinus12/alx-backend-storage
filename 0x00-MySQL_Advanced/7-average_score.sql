DELIMITER //

CREATE PROCEDURE add_correction(
    IN p_user_id INT,
    IN p_project_id INT,
    IN p_score INT
)
BEGIN
    DECLARE total_score INT;
    DECLARE correction_count INT;
    
    -- Insert the new correction
    INSERT INTO corrections (user_id, project_id, score) 
    VALUES (p_user_id, p_project_id, p_score);
    
    -- Calculate the new average score for the user
    SELECT SUM(score) INTO total_score
    FROM corrections
    WHERE user_id = p_user_id;
    
    SELECT COUNT(*) INTO correction_count
    FROM corrections
    WHERE user_id = p_user_id;
    
    -- Update the user's average score
    UPDATE users
    SET average_score = total_score / correction_count
    WHERE id = p_user_id;
END //

DELIMITER ;
