import CoreWLAN

if let iface = CWWiFiClient.shared().interface() {
    print(iface.rssiValue())
} else {
    print("off")
}
