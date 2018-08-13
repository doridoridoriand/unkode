<?php

require_once __DIR__ . '/vendor/autoload.php';

function hex128() {
  $str = '';
  for ($i = 0; $i < 5; $i++) {
    $str .= md5(uniqid('', true));
  };
  return mb_strimwidth($str, 0, 128);
}

# 配列の番号を書けば、そこの値を返す関数
function options($obj, $index) {
  return $obj[$index];
}

$arguments = [
  # [short option, long option, required or not, discript]
  ['s', 'size',           true, 'File size(GB)'],
  ['f', 'filename',       true, 'Output filename'],
  ['d', 'directory-path', true, 'Output directory with full path']
];

#$short_options = foreach ($argumetns)
#$long_options  = 
$options = getopt($short_options, $long_options);

eval(\Psy\sh());

# 全ての項目が存在するか自前でバリデーションを作らないといけない
$short_options_split = explode(':', $short_options);

