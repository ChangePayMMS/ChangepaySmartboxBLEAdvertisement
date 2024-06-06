import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ble_advertisement_platform_interface.dart';

/// An implementation of [BleAdvertisementPlatform] that uses method channels.
class MethodChannelBleAdvertisement extends BleAdvertisementPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ble_advertisement');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
    @override
  Future<String?> startAdvertisement(String orderId, String boxAuth) async {
    String result;
    try {
      result = await methodChannel.invokeMethod(
        'startAdvertisement',
        {
          "orderId": orderId,
          "boxAuth": boxAuth,
        },
      );
      result = "Advertising $result";
    } catch (err) {
      throw BlePluginException(
        statusCode: 1,
        message: "Unable to start advertisement. error : $err",
      );
    }
    return result;
  }

  @override
  Future<String?> stopAdvertisement() async {
    String result;
    try {
      result = await methodChannel.invokeMethod('stopAdvertisement');
    } catch (err) {
      throw BlePluginException(
        statusCode: 2,
        message: "Unable to stop the advertisement. error : $err",
      );
    }
    return result;
  }

  @override
  Future<bool?> get isAdvertising async {
    try {
      return await methodChannel.invokeMethod('isAdvertising');
    } catch (err) {
      throw BlePluginException(
        statusCode: 3,
        message: "Unable to check for bluetooth Advertisement status",
      );
    }
  }

  @override
  Future<bool?> get isBluetothEnabled async {
    try {
      return await methodChannel.invokeMethod('isBluetoothEnabled');
    } catch (err) {
      throw BlePluginException(
        statusCode: 4,
        message: "Unable to check for bluetooth status",
      );
    }
  }
}

class BlePluginException implements Exception {
  final int statusCode;
  final String message;

  BlePluginException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() {
    return 'BlePluginException(code: $statusCode, msg: $message)';
  }
}
