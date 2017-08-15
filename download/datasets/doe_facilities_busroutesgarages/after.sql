ALTER TABLE doe_facilities_busroutesgarages ADD COLUMN hash text;
UPDATE doe_facilities_busroutesgarages SET hash = md5(CAST((Vendor_Name,Garage_Street_Address,Garage_City,Garage_Zip,XCoordinates,YCoordinates) AS text));
