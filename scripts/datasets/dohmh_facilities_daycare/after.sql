ALTER TABLE dohmh_facilities_daycare ADD COLUMN hash text;
UPDATE dohmh_facilities_daycare SET hash = md5(CAST((Day_Care_ID,Center_Name,Legal_Name,Building,Street,ZipCode,Borough,facility_type,child_care_type,program_type,Maximum_Capacity) AS text));
