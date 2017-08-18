UPDATE facilities
    SET
        facname = TRIM(both ' ' from facname),
        factype = TRIM(both ' ' from factype),
        opname = TRIM(both ' ' from opname),
        streetname = TRIM(both ' ' from streetname),
        address = TRIM(both ' ' from address)
        ;

UPDATE facilities
    SET
        facname = TRIM(both '''' from facname),
        factype = TRIM(both '''' from factype),
        opname = TRIM(both '''' from opname),
        streetname = TRIM(both '''' from streetname),
        address = TRIM(both '''' from address)
        ;

UPDATE facilities
    SET
        facname = TRIM(both ' ' from facname),
        factype = TRIM(both ' ' from factype),
        opname = TRIM(both ' ' from opname),
        streetname = TRIM(both ' ' from streetname),
        address = TRIM(both ' ' from address)
        ;