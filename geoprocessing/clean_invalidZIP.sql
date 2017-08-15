UPDATE facilities 
    SET 
        zipcode = NULL
    WHERE
        zipcode = '0'
        OR zipcode = '83'
    ;