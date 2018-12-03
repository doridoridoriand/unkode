<?php

require_once __DIR__ . '/vendor/autoload.php';

use Ramsey\Uuid\Uuid;
use Ramsey\Uuid\Exception\UnsatisfiedDependencyException;


for ($i = 0; $i < 100; $i++) {
  $uuid4 = Uuid::uuid4();
  printf($uuid4->toString() . "\n");
}

