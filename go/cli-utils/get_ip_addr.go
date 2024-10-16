package main

import (
	"encoding/json"
	"fmt"
	"net"
)

func getIPAddr() {
    // Get a list of all network interfaces
    interfaces, err := net.Interfaces()
    if err != nil {
        fmt.Println("Error:", err)
        return
    }

    // Create a slice to hold interface details
    var ifaceDetails []map[string]interface{}

    // Iterate over each interface
    for _, iface := range interfaces {
        // Get a list of addresses associated with the interface
        addrs, err := iface.Addrs()
        if err != nil {
            fmt.Println("Error:", err)
            return
        }

        // Create a map to hold details of the current interface
        ifaceDetail := map[string]interface{}{
            "Name":  iface.Name,
            "Flags": iface.Flags.String(),
        }

        // Create a slice to hold IP addresses
        var ipAddrs []string

        // Iterate over each address
        for _, addr := range addrs {
            // Check if the address is an IP address
            ipNet, ok := addr.(*net.IPNet)
            if ok && ipNet.IP.To4() != nil {
                // Append the IPv4 address to the list
                ipAddrs = append(ipAddrs, ipNet.IP.String())
            }
        }

        // Add IP addresses to the interface details
        ifaceDetail["IPAddresses"] = ipAddrs

        // Append the interface detail to the list
        ifaceDetails = append(ifaceDetails, ifaceDetail)
    }

    // Marshal the interface details to JSON
    jsonData, err := json.MarshalIndent(ifaceDetails, "", "  ")
    if err != nil {
        fmt.Println("Error marshalling to JSON:", err)
        return
    }

    // Print the JSON data
    fmt.Println(string(jsonData))
}

func main() {
    getIPAddr()
}
