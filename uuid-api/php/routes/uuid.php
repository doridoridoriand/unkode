<?php

// ここに書くのが正しいのかイマイチ分かってない
// helperクラスとか用意 or mix-in的なやつ用意してinclude?
use Ramsey\Uuid\Uuid;
use Ramsey\Uuid\Exception\UnsatisfiedDependencyException;

$router->get('/', function () use ($router) {
  $uuid4 = Uuid::uuid4();
  return response()->json(['uuid' => $uuid4->toString()]);
});

