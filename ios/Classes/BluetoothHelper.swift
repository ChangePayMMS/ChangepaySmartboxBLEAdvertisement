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
        guard let serviceUUID = UUID(uuidString: "0BC42DB3-B4B0-413A-82B7-44012F720AFE") else {
            return
        }

        let payloadCharacterstic = CBMutableCharacteristic(
            type: CBUUID(nsuuid: UUID()),
            properties: [.read],
            value: "\(orderId);\(boxAuth)".data(using: .utf8),
            permissions: .readable
        )
        
        let advService = CBMutableService(type: CBUUID(nsuuid: serviceUUID), primary: true)
        advService.characteristics = [payloadCharacterstic]
        peripheralManager?.add(advService)
        
        let advertisementData = [
            CBAdvertisementDataLocalNameKey: "iOS-Device-BLE-Smartbox-Adv",
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

