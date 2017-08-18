-- REMEMBER NOT TO COPY AND PASTE FACNAME IN THE OTHER FIELDS

UPDATE facilities
	SET factype = initcap(factype)
	WHERE
		upper(factype) = factype
		AND factype <> 'IMPACT'
		AND factype <> 'COMPASS'
		AND factype <> 'WIOA CUNY MOU'
	;

UPDATE facilities
	SET facname = initcap(facname)
	WHERE
		upper(facname) = facname
	;

UPDATE facilities
	SET opname = initcap(opname)
	WHERE
		upper(opname) = opname
	;

UPDATE facilities AS f
    SET 
		facname =
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(facname, 'Nycha', 'NYCHA'),
			'Nyu', 'NYU'),
			'Nycta', 'NYCTA'),
			'Nyct', 'NYCT'),
			'Nyc', 'NYC'),
			'Nypd', 'NYPD'),
			'Ny', 'NY'),
			'Swd', 'Students with Disabilities'),
			'Usda-Ceo', 'USDA-CEO'),
			'Usda', 'USDA'),
			'Ged', 'GED'),
			'Cuny', 'CUNY'),
			'Suny', 'SUNY'),
			'Wep', 'Work Experience Program'),
			'Esl', 'ESL'),
			'Llc', 'LLC'),
			'Ps', 'PS'),
			'Fdny', 'FDNY'),
			'Sped', 'SPED'),
			'Hs', 'HS'),
			'Ps/Is', 'PS/IS'),
			'Is ', 'IS '),
			'Ii', 'II'),
			'Ymca', 'YMCA'),
			'''S', '''s'),
			'Tlc', 'TLC'),
			'Bx', 'BX'),
			'Mn', 'MN'),
			'Si ', 'SI '),
			'Ccc', 'CCC'),
			'Dcc', 'DCC'),
			'Ura', 'URA'),
			'Ta ', 'TA '),
		factype =
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(factype, 'Nycha', 'NYCHA'),
			'Nyu', 'NYU'),
			'Nycta', 'NYCTA'),
			'Nyct', 'NYCT'),
			'Nyc', 'NYC'),
			'Nypd', 'NYPD'),
			'Ny', 'NY'),
			'Swd', 'Students with Disabilities'),
			'Usda-Ceo', 'USDA-CEO'),
			'Usda', 'USDA'),
			'Ged', 'GED'),
			'Cuny', 'CUNY'),
			'Suny', 'SUNY'),
			'Wep', 'Work Experience Program'),
			'Esl', 'ESL'),
			'Llc', 'LLC'),
			'Ps', 'PS'),
			'Fdny', 'FDNY'),
			'Sped', 'SPED'),
			'Hs', 'HS'),
			'Ps/Is', 'PS/IS'),
			'Is ', 'IS '),
			'Ii', 'II'),
			'Ymca', 'YMCA'),
			'''S', '''s'),
			'Tlc', 'TLC'),
			'Bx', 'BX'),
			'Mn', 'MN'),
			'Si ', 'SI '),
			'Ccc', 'CCC'),
			'Dcc', 'DCC'),
			'Ura', 'URA'),
			'Ta ', 'TA '),
		opname =
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(opname, 'Nycha', 'NYCHA'),
			'Nyu', 'NYU'),
			'Nycta', 'NYCTA'),
			'Nyct', 'NYCT'),
			'Nyc', 'NYC'),
			'Nypd', 'NYPD'),
			'Ny', 'NY'),
			'Swd', 'Students with Disabilities'),
			'Usda-Ceo', 'USDA-CEO'),
			'Usda', 'USDA'),
			'Ged', 'GED'),
			'Cuny', 'CUNY'),
			'Suny', 'SUNY'),
			'Wep', 'Work Experience Program'),
			'Esl', 'ESL'),
			'Llc', 'LLC'),
			'Ps', 'PS'),
			'Fdny', 'FDNY'),
			'Sped', 'SPED'),
			'Hs', 'HS'),
			'Ps/Is', 'PS/IS'),
			'Is ', 'IS '),
			'Ii', 'II'),
			'Ymca', 'YMCA'),
			'''S', '''s'),
			'Tlc', 'TLC'),
			'Bx', 'BX'),
			'Mn', 'MN'),
			'Si ', 'SI '),
			'Ccc', 'CCC'),
			'Dcc', 'DCC'),
			'Ura', 'URA'),
			'Ta ', 'TA ');
