UPDATE facilities 
    SET 
        City = 
            (CASE 
                WHEN Boro = 'Manhattan' THEN 'New York'
                ELSE Boro
            END)
    WHERE
        Boro <> 'Queens'
    ;

UPDATE facilities 
    SET 
        Boro = 
        (CASE 
            WHEN City = 'New York' THEN 'Manhattan'
            WHEN City = 'Bronx' THEN 'Bronx'
            WHEN City = 'Brooklyn' THEN 'Brooklyn'
            WHEN City = 'Staten Island' THEN 'Staten Island'
            ELSE 'Queens'
        END)
    WHERE
        Boro IS NULL
        AND City IS NOT NULL
    ;