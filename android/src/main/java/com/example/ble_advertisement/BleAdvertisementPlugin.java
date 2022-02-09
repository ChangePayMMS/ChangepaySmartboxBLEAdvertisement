package com.example.ble_advertisement;

import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** BleAdvertisementPlugin */
public class BleAdvertisementPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native
  /// Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine
  /// and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ble_advertisement");
    channel.setMethodCallHandler(this);
  }

  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    BluetoothHelper bluetoothHelper = BluetoothHelper.getInstance();

    if (call.method.equals("startAdvertisement")) {
      String orderId = call.argument("orderId");
      String boxAuth = call.argument("boxAuth");
      boolean res = bluetoothHelper.isBluetoothEnabled();
      if (!res) {
        result.error("1", "Bluetooth is off", "Turn on the device bluetooth to continue");
      } else {
        bluetoothHelper.startAdvertisement(orderId, boxAuth);
        result.success(orderId + ',' + boxAuth);
      }
    } else if (call.method.equals("stopAdvertisement")) {
      bluetoothHelper.stopAdvertisement();
      result.success("0");
    } else if (call.method.equals("isAdvertising")) {
      result.success(bluetoothHelper.isAdvertising());
    } else if (call.method.equals("isBluetoothEnabled")) {
      result.success(bluetoothHelper.isBluetoothEnabled());
    }
    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
