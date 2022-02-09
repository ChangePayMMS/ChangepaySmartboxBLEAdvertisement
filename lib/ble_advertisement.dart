import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BleAdvertisement {
  static const MethodChannel _channel =
      const MethodChannel('ble_advertisement');

  static Future<String?> startAdvertisement(
      String orderId, String boxAuth) async {
    String result;
    try {
      result = await _channel.invokeMethod('startAdvertisement', {
        "orderId": orderId,
        "boxAuth": boxAuth,
      });
      result = "Advertising " + result;
    } catch (err) {
      throw BlePluginException(
        statusCode: 1,
        message: "Unable to start advertisement. error : $err",
      );
    }
    return result;
  }

  static Future<String?> stopAdvertisement() async {
    String result;
    try {
      result = await _channel.invokeMethod('stopAdvertisement');
    } catch (err) {
      throw BlePluginException(
        statusCode: 2,
        message: "Unable to stop the advertisement. error : $err",
      );
    }
    return result;
  }

  static Future<bool?> get isAdvertising async {
    try {
      return await _channel.invokeMethod('isAdvertising');
    } catch (err) {
      throw BlePluginException(
        statusCode: 3,
        message: "Unable to check for bluetooth Advertisement status",
      );
    }
  }

  static Future<bool?> get isBluetothEnabled async {
    try {
      return await _channel.invokeMethod('isBluetoothEnabled');
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
