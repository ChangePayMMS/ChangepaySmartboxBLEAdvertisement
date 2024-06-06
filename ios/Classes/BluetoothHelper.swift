//
//  BluetoothHelper.swift
//  ble_advertisement
//
//  Created by Sumit Pradhan on 06/06/24.
//

import UIKit
import CoreBluetooth

class BluetoothAdvertisementHelper: NSObject, CBPeripheralManagerDelegate {

    private var peripheralManager: CBPeripheralManager?
    var changepayCompanyId = "CPAY0"
    var isBluetoothEnabled = false

    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    private func encode(orderId: String, boxAuth: String) -> String {
        return "\(changepayCompanyId);\(orderId);\(boxAuth)"
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            isBluetoothEnabled = true
        case .poweredOff, .resetting, .unauthorized, .unsupported, .unknown:
            isBluetoothEnabled = false
        @unknown default:
            stopAdvertising()
        }
    }

    func startAdvertising(orderId: String, boxAuth: String) {
        let advertisementData = [
            CBAdvertisementDataLocalNameKey: encode(orderId: orderId, boxAuth: boxAuth),
            CBAdvertisementDataServiceUUIDsKey: [CBUUID(nsuuid: UUID())],
            CBAdvertisementDataManufacturerDataKey: NSData(data: encode(orderId: orderId, boxAuth: boxAuth).data(using: .utf8)!),
            "hello": "World"
        ] as [String : Any]
        peripheralManager?.startAdvertising(advertisementData)
        print("Started advertising: \(String(describing: advertisementData))")
    }

    func stopAdvertising() {
        peripheralManager?.stopAdvertising()
        print("Stopped advertising")
    }
    
    func isAdvertising() -> Bool? {
        return peripheralManager?.isAdvertising
    }
}

