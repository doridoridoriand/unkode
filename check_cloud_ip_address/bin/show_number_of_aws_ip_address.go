package main

import (
	"encoding/json"
	"io"
	"log"
	"net/http"
	"net/netip"
)

type AwsIpAddresses struct {
	SyncToken  string `json:"syncToken"`
	CreateDate string `json:"createDate"`
	Prefixes   []struct {
		IPPrefix           string `json:"ip_prefix"`
		Region             string `json:"region"`
		Service            string `json:"service"`
		NetworkBorderGroup string `json:"network_border_group"`
	} `json:"prefixes"`
	Ipv6Prefixes []struct {
		Ipv6Prefix         string `json:"ipv6_prefix"`
		Region             string `json:"region"`
		Service            string `json:"service"`
		NetworkBorderGroup string `json:"network_border_group"`
	} `json:"ipv6_prefixes"`
}

func main() {
	log.Println("Start to parse IP addresses ranges of AWS.")

	resp, err := http.Get("https://ip-ranges.amazonaws.com/ip-ranges.json")
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()

	data_raw, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}

	var awsIpAccesses AwsIpAddresses
	if err := json.Unmarshal(data_raw, &awsIpAccesses); err != nil {
		log.Fatal(err)
	}

	var ipv4Cidrs []string
	ipv4Prefixes := awsIpAccesses.Prefixes
	for i := range ipv4Prefixes {
		ipv4Cidrs = append(ipv4Cidrs, ipv4Prefixes[i].IPPrefix)
	}
	log.Println("Number of IPv4 CIDR blocks:", len(ipv4Cidrs))

	var numOfIps []int
	for i := range ipv4Cidrs {
		numOfIps = append(numOfIps, cidrToIPs(ipv4Cidrs[i]))
	}

	totalNumOfIPs := 0
	for i := range numOfIps {
		totalNumOfIPs += numOfIps[i]
	}
	log.Println("Completed to calculate number of IPv4 addresses. Number of IPv4 address of AWS:", totalNumOfIPs)

}
func cidrToIPs(cidr string) int {
	prefix, err := netip.ParsePrefix(cidr)
	if err != nil {
		log.Println("Something wring with CIDR:", cidr)
		panic(err)
	}

	var ips []netip.Addr
	for addr := prefix.Addr(); prefix.Contains(addr); addr = addr.Next() {
		ips = append(ips, addr)
	}
	return len(ips)
}
