package main

import (
	"fmt"
	"net"
	"runtime"
	"strconv"
	"sync"
	"time"
)

// TODO: FIX
// - UDP is giving wrong results

func main() {
	runtime.GOMAXPROCS(4)
	count := 255
	var wg sync.WaitGroup
	port := "22"
	timeout := time.Second
	var tcpOpen []string
	// var udpOpen []string
	for index := 1; index < count; index++ {
		wg.Add(1)
		host := "192.168.0." + strconv.Itoa(index)
		go func() {
			defer wg.Done()
			conn, err := net.DialTimeout("tcp", net.JoinHostPort(host, port), timeout)
			if err != nil {
			}
			if conn != nil {
				defer conn.Close()
				tcpOpen = append(tcpOpen, host)
			}
			// connUDP, err := net.DialTimeout("udp4", net.JoinHostPort(host, port), 60*timeout)
			// if err != nil {
			// 	fmt.Println(err)
			// }
			// if connUDP != nil {
			// 	defer connUDP.Close()
			// 	udpOpen = append(udpOpen, host)
			// }
		}()
	}
	wg.Wait()
	fmt.Println("TCP Open List: ", tcpOpen)
	// fmt.Println("UDP Open List: ", udpOpen)
}
