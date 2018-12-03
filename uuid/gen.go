package main

import (
  "fmt"
  "github.com/satori/go.uuid"
)


func sayHi() {
  fmt.Println("HelloWorld")
}

func main() {
  //sayHi()
  u1 := uuid.Must(uuid.NewV4())
  fmt.Printf("UUIDv4: %s\n", u1)

  for ;; {
    u1 := uuid.Must(uuid.NewV4())
    fmt.Println(u1)
  }
}
