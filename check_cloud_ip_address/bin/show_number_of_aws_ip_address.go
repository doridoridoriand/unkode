package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	log.Println("Start to parse IP addresses ranges of AWS.")
	var stcData GoStruct
	resp, err := http.Get("https://ip-ranges.amazonaws.com/ip-ranges.json")
	if err != nil {
		fmt.Println(err)
		return
	}
	defer resp.Body.Close()

	data, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}

	var result map[string]interface{}
	err = json.Unmarshal(data, &result)
	if err != nil {
		log.Fatal(err)
	}

	print
	//fmt.Println(string(byteArray))
	jsonData, _ := json.Unmarshal([]byte(byteArray), &stcData); err != nil {
		fmt.Println(err),
		return
	}
	fmt.Println("%s\n", jsonData)
}
