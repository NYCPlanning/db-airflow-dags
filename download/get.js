// Args passed in
var dataset = process.argv[2];
var argv = require('minimist')(process.argv.slice(3));

var download_dir = argv.download_dir + "/";

ftpAuth = {
  username: argv.ftp_user,
  password: argv.ftp_pass
}

//load dependencies
var download = require('download-file'),
  unzip = require('unzip'),
  fs = require('fs-extra'),
  Mustache = require('mustache')
  FTP = require('ftp-get')

var dirPath = './datasets/' + dataset;

//get the configuration for this dataset from its data.json file
var config = require(dirPath + '/data.json')

//use defined saveFile name or usr the URL
config.saveFile = config.saveFile || getFilename(config.url);
config.writePath = download_dir + dataset;

console.log('Downloading dataset ' + dataset + ' from ' + config.url)

//check if HTTP or FTP
if(config.url.indexOf('http') > -1) {
  return getHTTP(config);
} else if (config.url.indexOf('ftp') > -1) {
  return getFTP(config);
}

function getHTTP(config) {
  return new Promise(
    function(resolve, reject) {


        var options = {
          directory: config.writePath,
          filename: config.saveFile
        }
        download(config.url, options, function(err){
        if (err) throw err

        console.log('Saved file to ' + config.writePath + '/' + config.saveFile)
        var ext = getExtension(config.saveFile);
        if (ext=='zip') {

          console.log('Unzipping ' + config.writePath + '/' + config.saveFile)
          var stream = fs.createReadStream(config.writePath + '/' + config.saveFile)
            .pipe(unzip.Extract({ path: config.writePath }));

          stream.on('close', function() {
            resolve();
          })
        } else {
          resolve();
        }
      })
    }
  )
}


function getFTP(config) {
  return new Promise(
    function(resolve, reject) {

      config.url=Mustache.render(config.url, ftpAuth)
      fs.emptyDirSync(config.writePath);

      FTP.get(config.url, config.writePath + '/' + config.saveFile, function (err, res) {
        if(!err) {
          console.log('Saved file to ' + config.writePath + '/' + config.saveFile)
          var ext = getExtension(config.saveFile);
          if (ext=='zip') {
            console.log('Unzipping ' + config.writePath + '/' + config.saveFile)
            fs.createReadStream(config.writePath + '/' + config.saveFile)
              .pipe(unzip.Extract({ path: config.writePath }));
            resolve();
          } else {
            resolve();
          }
        }
      })
    }
  );
}

// get everything to the right of the last /... this should be the filename. But maybe not.
function getFilename(url) {
    return url.split('/').pop();
}

//get file extension from filename
function getExtension(filename) {
    return filename.split('.').pop();
}
