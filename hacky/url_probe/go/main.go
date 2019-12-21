package main

import (
	"fmt"
	"net/http"
	"runtime"
	"strconv"
	"sync"
	"time"
)

func main() {
	runtime.GOMAXPROCS(4)
	count := 255
	var wg sync.WaitGroup
	for index := 1; index < count; index++ {
		wg.Add(1)
		url := "http://192.168.1." + strconv.Itoa(index) + "/phpmyadmin"
		go func() {
			defer wg.Done()

			check, checkString := checkHTTP(url)
			if check != true {
				// fmt.Println("---------------")
				// fmt.Println(url)
				// fmt.Println(checkString)
				// fmt.Println("<--------------->")
			} else {
				fmt.Println("---------------")
				fmt.Println(url)
				fmt.Println(checkString)
				fmt.Println("<--------------->")
			}
		}()
	}
	wg.Wait()
}

func checkHTTP(url string) (bool, string) {
	timeout := time.Duration(10 * time.Second)
	client := http.Client{
		Timeout: timeout,
	}
	resp, err := client.Get(url)
	if err != nil {
		return false, err.Error()
	} else {
		return true, string(resp.StatusCode) + resp.Status
	}
}
