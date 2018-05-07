<?php

function hex128() {
  $str = '';
  for ($i = 0; $i < 5; $i++) {
    $str .= md5(uniqid('', true));
  };
  return mb_strimwidth($str, 0, 128);
}

var_dump(getopt('s:f:d'));
