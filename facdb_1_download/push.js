var Mustache = require('mustache')
var c = require('child_process');
var fs = require('fs');

var dataset = process.argv[2];
var dirPath = './datasets/' + dataset;

var argv = require('minimist')(process.argv.slice(3));

var download_dir = argv.download_dir + "/";

db = {
  database: argv.db,
  user: argv.db_user,
}

//get the configuration for this dataset from its data.json file
var config = require(dirPath + '/data.json')

//shp2pgsql method
if(config.load == 'shp2pgsql') {
  console.log('Pushing into database using ' + config.load + '...');

  for (file of config.loadFiles) {
    var filePath = download_dir + dataset + '/' + file.file

    if (!fs.existsSync(filePath)) {
      console.log('Error: data file is missing - ', filePath)
      process.exit(1);
    }

    var shp2pgsqlOptions = {
      options: config.shp2pgsql.join(' '),
      filePath: filePath,
      database: db.database,
      user: db.user,
      table: file.table
    }

    var shp2pgsql = Mustache.render('shp2pgsql {{options}} {{{filePath}}} {{table}} | psql -d {{database}} -U {{user}}', shp2pgsqlOptions);

    console.log('Executing: ' + shp2pgsql);
    var response = c.execSync(shp2pgsql);
    console.log('Done', response);
  }
}


//org2ogr method
if(config.load == 'org2ogr') {
  console.log('Pushing into database using ' + config.load + '...');

  for (file of config.loadFiles) {
    var filePath = download_dir + dataset + '/' + file.file

    var ogr2ogrOptions = {
      options: config.ogr2ogr.join(' '),
      filePath: filePath,
      database: db.database,
      user: db.user,
      table: file.table
    }

    var ogr2ogr = Mustache.render("ogr2ogr -f 'PostgreSQL' PG:'dbname={{database}} user={{user}}' {{{filePath}}} -nln {{table}} -overwrite {{options}}", ogr2ogrOptions);

    console.log('Executing: ' + ogr2ogr);
    var response = c.execSync(ogr2ogr);
    console.log('Done', response);
  }
}

//csv method
if(config.load == 'csv') {
  console.log('Pushing into database using ' + config.load + '...');

  for (file of config.loadFiles) {
    var filePath = download_dir + dataset + '/' + file.file

    config.csv.forEach(function(action) {
      console.log(action);

      if(action == 'create') {
        var command = Mustache.render('psql -d {{database}} -U {{user}} -f {{{path}}}{{action}}.sql', {
          user: db.user,
          database: db.database,
          path: 'datasets/' + dataset + '/',
          action: action
        });

        console.log('Executing psql: ' + command)
        var response = c.execSync(command)
        console.log('Done', response)
      }

      if(action == 'copy') {
        var loadFile = file.file;

        var command = Mustache.render('psql -d {{database}} -U {{user}} -c "\\COPY {{dataset}} FROM \'{{{filePath}}}\' CSV HEADER;"', {
          user: db.user,
          database: db.database,
          path: 'datasets/' + dataset + '/',
          filePath: filePath,
          dataset: dataset
        });

        console.log('Executing psql: ' + command)
        var response = c.execSync(command)
        console.log('Done', response)
      }
    });
  }
}
