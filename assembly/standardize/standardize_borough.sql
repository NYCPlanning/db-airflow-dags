UPDATE facilities 
    SET 
    	boro =
    		(CASE
	    		WHEN trim(boro, ' ') = 'New York' THEN 'Manhattan'
                WHEN trim(boro, ' ') = 'NEW YORK' THEN 'Manhattan'
                WHEN trim(boro, ' ') = 'MANHATTAN' THEN 'Manhattan'
                WHEN trim(boro, ' ') = 'Manhattan' THEN 'Manhattan'

                WHEN trim(boro, ' ') = 'BRONX' THEN 'Bronx'
                WHEN trim(boro, ' ') = 'Bronx' THEN 'Bronx'

                WHEN trim(boro, ' ') = 'Kings' THEN 'Brooklyn'
                WHEN trim(boro, ' ') = 'KINGS' THEN 'Brooklyn'
                WHEN trim(boro, ' ') = 'BROOKLYN' THEN 'Brooklyn'
                WHEN trim(boro, ' ') = 'Brooklyn' THEN 'Brooklyn'

                WHEN trim(boro, ' ') = 'QUEENS' THEN 'Queens'
                WHEN trim(boro, ' ') = 'Queens' THEN 'Queens'

                WHEN trim(boro, ' ') = 'Richmond' THEN 'Staten Island'
                WHEN trim(boro, ' ') = 'RICHMOND' THEN 'Staten Island'
                WHEN trim(boro, ' ') = 'STATEN ISLAND' THEN 'Staten Island'
                WHEN trim(boro, ' ') = 'Staten Island' THEN 'Staten Island'
                WHEN trim(boro, ' ') = 'Staten Is' THEN 'Staten Island'
	    	END),
        borocode =
            (CASE
                WHEN trim(boro, ' ') = 'New York' THEN 1
                WHEN trim(boro, ' ') = 'NEW YORK' THEN 1
                WHEN trim(boro, ' ') = 'MANHATTAN' THEN 1
                WHEN trim(boro, ' ') = 'Manhattan' THEN 1

                WHEN trim(boro, ' ') = 'BRONX' THEN 2
                WHEN trim(boro, ' ') = 'Bronx' THEN 2

                WHEN trim(boro, ' ') = 'Kings' THEN 3
                WHEN trim(boro, ' ') = 'KINGS' THEN 3
                WHEN trim(boro, ' ') = 'BROOKLYN' THEN 3
                WHEN trim(boro, ' ') = 'Brooklyn' THEN 3

                WHEN trim(boro, ' ') = 'QUEENS' THEN 4
                WHEN trim(boro, ' ') = 'Queens' THEN 4
                
                WHEN trim(boro, ' ') = 'Richmond' THEN 5
                WHEN trim(boro, ' ') = 'RICHMOND' THEN 5
                WHEN trim(boro, ' ') = 'STATEN ISLAND' THEN 5
                WHEN trim(boro, ' ') = 'Staten Island' THEN 5
                WHEN trim(boro, ' ') = 'Staten Is' THEN 5
            END);
