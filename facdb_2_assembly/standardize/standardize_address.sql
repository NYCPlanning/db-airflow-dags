UPDATE facilities
    SET
        addressnum = REPLACE(addressnum,'One','1'),
        address = split_part(trim(split_part(address, 'New York, N', 1),' '),',',1),
        streetname = split_part(trim(split_part(streetname, 'New York, N', 1),' '),',',1)
        ;

UPDATE facilities
    SET
        streetname = initcap(REPLACE(streetname,'''','')),
        address = initcap(REPLACE(address,'''',''))
    WHERE address LIKE '%''%' AND (streetname NOT LIKE 'O%' OR streetname IS NULL)
        ;

CREATE OR REPLACE FUNCTION isnumeric(text) RETURNS BOOLEAN AS $$
DECLARE x NUMERIC;
BEGIN
    x = $1::NUMERIC;
    RETURN TRUE;
EXCEPTION WHEN others THEN
    RETURN FALSE;
END;
$$
STRICT
LANGUAGE plpgsql IMMUTABLE;

UPDATE facilities
    SET
    addressnum = 
    	(CASE WHEN isnumeric(REPLACE(addressnum,'-','')) AND addressnum <> '0' THEN addressnum
    		ELSE NULL
    	END),
    streetname =
        (CASE WHEN isnumeric(REPLACE(addressnum,'-','')) AND addressnum <> '0' THEN streetname
    		ELSE NULL
    	END)
    ;