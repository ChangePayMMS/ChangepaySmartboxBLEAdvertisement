import Flutter
import UIKit
import OSLog

@available(iOS 14.0, *)
public class BleAdvertisementPlugin: NSObject, FlutterPlugin {
  var bluetoothHelper = BluetoothAdvertisementHelper()
  var logger = Logger()
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ble_advertisement", binaryMessenger: registrar.messenger())
    let instance = BleAdvertisementPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "startAdvertisement":
        guard let args = call.arguments as? [String: Any] else {
            return
        }
        guard let orderId = args["orderId"] as? String else {
            return
        }
        guard let boxAuth = args["boxAuth"] as? String else {
            return
        }
        if bluetoothHelper.isBluetoothEnabled {
            bluetoothHelper.startAdvertising(orderId: orderId, boxAuth: boxAuth)
            result("0")
        }
    case "stopAdvertisement":
      bluetoothHelper.stopAdvertising();
      result("0");
    case "isAdvertising":
      result(bluetoothHelper.isAdvertising())
    case "isBluetoothEnabled":
      result(bluetoothHelper.isBluetoothEnabled)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
