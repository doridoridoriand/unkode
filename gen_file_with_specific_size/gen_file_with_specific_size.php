<?php

function hex128() {
  $str = '';
  for ($i = 0; $i < 5; $i++) {
    $str .= md5(uniqid('', true));
  };
  return mb_strimwidth($str, 0, 128);
}

$arguments = [
  ['s', 'size'],
  ['f', 'filename'],
  ['d', 'directory-path']
];

$short_options = 
$long_options  = 
$options = getopt($short_options, $long_options);

# 全ての項目が存在するか自前でバリデーションを作らないといけない
$short_options_split = explode(':', $short_options);

