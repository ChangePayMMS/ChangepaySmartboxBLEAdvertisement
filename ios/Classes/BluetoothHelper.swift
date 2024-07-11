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
        let boxAuthUUID = UUID()
        let orderIdUUID = UUID()
        let serviceUUID = UUID()
        print("Box UUID: \(boxAuthUUID)")
        print("orderId UUID: \(orderIdUUID)")
        print("Service UUID: \(serviceUUID)")
        let c1 = CBMutableCharacteristic(
            type: CBUUID(nsuuid: orderIdUUID),
            properties: [.read],
            value: orderId.data(using: .utf8),
            permissions: .readable
        )
        let c2 = CBMutableCharacteristic(
            type: CBUUID(nsuuid: boxAuthUUID),
            properties: [.read],
            value: boxAuth.data(using: .utf8),
            permissions: .readable
        )
        
        let advService = CBMutableService(type: CBUUID(nsuuid: serviceUUID), primary: true)
        advService.characteristics = [c1, c2]
        peripheralManager?.add(advService)
        let advertisementData = [
            CBAdvertisementDataLocalNameKey: "iOS-Device-BLE-Smartbox-Req",
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

