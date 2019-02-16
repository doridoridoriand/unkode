package main

import (
	"flag"
	"fmt"
)

var (
	boolFlag   bool
	intFlag    int
	stringFlag string
)

func register() {
	flag.BoolVar(&boolFlag, "bool", false, "help message of `b` option")
	flag.BoolVar(&boolFlag, "b", false, "")
	flag.IntVar(&intFlag, "int", 1234, "help message of `i` option")
	flag.IntVar(&intFlag, "i", 1234, "")
	flag.StringVar(&stringFlag, "string", "default", "help message of `s` option")
	flag.StringVar(&stringFlag, "s", "default", "")

	flag.Parse()
}

func main() {
	register()

	fmt.Println(boolFlag)
	fmt.Println(intFlag)
	fmt.Println(stringFlag)
}
