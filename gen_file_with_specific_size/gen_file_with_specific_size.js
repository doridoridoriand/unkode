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
  name:        'directory-path',
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

console.log(arguments);

function hex128() {
  // なんかtoString('hex')で変換すると256文字帰ってくるので半分の64bytesで生成している
  return crypto.randomBytes(64).toString('hex');
}

// 指定したディレクトリが存在しなかったら例外

debugger;

directory_exists = path.dirname();

// 指定したファイルがすでに存在したら例外

