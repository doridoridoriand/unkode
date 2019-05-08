require "open-uri"
require "json"

res = JSON.parse(open("https://itunes.apple.com/search?term=kinggnu/").map {|r| r}.join)
search_results = res["results"]
puts search_results.select {|r| r["trackName"] === "Hakujitsu"}.first["collectionViewUrl"]
