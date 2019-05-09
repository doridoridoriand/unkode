<?php
require_once("vendor/autoload.php");

$ch = curl_init('https://itunes.apple.com/search?term=kinggnu/');
curl_setopt_array($ch, [CURLOPT_RETURNTRANSFER => true]);
$json           = json_decode(curl_exec($ch), true);
$search_results = $json["results"];

foreach($search_results as $v) {
  if ($v["trackName"] == "Hakujitsu") {
    echo($v["collectionViewUrl"]);
  }
}

