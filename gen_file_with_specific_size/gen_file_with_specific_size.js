let argv   = require('argv');
let crypto = require('crypto');
let path   = require('path');
let fs     = require('fs');

argv.option({
  name:        'size',
  short:       's',
  type:        'integer',
  description: 'File size(GB)',
  example:     '--size=10 or -s 10'
});
argv.option({
  name:        'directory_path',
  short:       'd',
  type:        'string',
  description: 'Please input absolute directory path.',
  example:     '--directory-path=/dev/null or -d /dev/null'
});
argv.option({
  name:        'filename',
  short:       'f',
  type:        'string',
  description: 'File name',
  example:     '--filename=hex_10GB.txt or -f hex_10GB.txt'
});
arguments = argv.run();

// すべて必須項目なので、一つでもなかったら例外
if (!arguments.options.filename)       { console.error('NoFilenameDetectedError');      process.exit(1); }
if (!arguments.options.directory_path) { console.error('NoDirectoryPathDetectedError'); process.exit(1); }
if (!arguments.options.size)           { console.error('NoFileSizeDetectedError');      process.exit(1); }

function hex128() {
  // なんかtoString('hex')で変換すると256文字帰ってくるので半分の64bytesで生成している
  return crypto.randomBytes(64).toString('hex');
}

// 指定したディレクトリが存在しなかったら例外
fs.stat(arguments.options.directory_path, function (err, stats) {
  if (err) {
    console.warn(err.message);
    process.exit(1);
  }
});

// 指定したファイルがすでに存在したら例外
fs.stat([arguments.options.directory_path, arguments.options.filename].join('/'), function (err, stats) {
  if (stats) {
    throw new Error('the file already exists');
  }
});

// 指定した容量が保存先のディスクの容量を上回っていたら例外で終了
