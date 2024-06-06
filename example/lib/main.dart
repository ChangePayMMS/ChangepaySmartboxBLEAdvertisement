import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ble_advertisement/ble_advertisement.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _bleAdvertisementPlugin = BleAdvertisement();

  late final TextEditingController orderIdTextFieldController;
  late final TextEditingController boxAuthTextFieldController;

  @override
  void initState() {
    handlePermission();
    orderIdTextFieldController = TextEditingController();
    boxAuthTextFieldController = TextEditingController();
    super.initState();
  }

  void handlePermission() {
    Permission.bluetoothAdvertise.request();
  }

  @override
  void dispose() {
    orderIdTextFieldController.dispose();
    boxAuthTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            handlePermission();
            _bleAdvertisementPlugin.startAdvertisement(
              orderIdTextFieldController.text,
              boxAuthTextFieldController.text,
            );
          },
          child: const Icon(CupertinoIcons.bluetooth),
        ),
        appBar: AppBar(
          title: const Text('Bluetooth Advertisement plugin'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: orderIdTextFieldController,
                decoration: const InputDecoration(hintText: 'Enter Order Id'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: boxAuthTextFieldController,
                decoration: const InputDecoration(hintText: 'Enter Box Auth'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
