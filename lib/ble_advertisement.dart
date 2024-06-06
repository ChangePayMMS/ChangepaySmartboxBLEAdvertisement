import 'dart:developer';

import 'ble_advertisement_platform_interface.dart';

class BleAdvertisement {
  Future<String?> getPlatformVersion() {
    return BleAdvertisementPlatform.instance.getPlatformVersion();
  }

  Future<String?> startAdvertisement(String orderId, String boxAuth) {
    return BleAdvertisementPlatform.instance
        .startAdvertisement(orderId, boxAuth);
  }

  Future<String?> stopAdvertisement() {
    return BleAdvertisementPlatform.instance.stopAdvertisement();
  }

  Future<bool?> get isAdvertising {
    return BleAdvertisementPlatform.instance.isAdvertising;
  }

  Future<bool?> get isBluetothEnabled {
    return BleAdvertisementPlatform.instance.isBluetothEnabled;
  }
}
