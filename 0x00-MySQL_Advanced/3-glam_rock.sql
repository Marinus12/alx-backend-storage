-- Create the query to list bands with Glam rock as their main style, ranked by longevity
SELECT 
    bands.name AS band_name, 
    CASE 
        WHEN bands.split IS NULL THEN 2022 - bands.formed
        ELSE bands.split - bands.formed
    END AS lifespan
FROM 
    bands
JOIN 
    styles ON bands.style_id = styles.id
WHERE 
    styles.name = 'Glam rock'
ORDER BY 
    lifespan DESC;
