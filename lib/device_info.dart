import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:device_information/device_information.dart';
import 'package:permission_handler/permission_handler.dart';


class DeviceInfoPage extends StatefulWidget {
  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  String _platformVersion = 'Unknown',
      _imeiNo = "",
      _modelName = "",
      _manufacturerName = "",
      _deviceName = "",
      _productName = "",
      _cpuType = "",
      _hardware = "";
  var _apiLevel;

  @override
  void initState() {
    super.initState();
    checkPermissionsAndInit();
  }

  Future<void> checkPermissionsAndInit() async {
    final status = await Permission.phone.request();

    if (status.isGranted) {
      await initPlatformState();
    } else {
      setState(() {
        _platformVersion = "Permission Denied";
      });
    }
  }

  Future<void> initPlatformState() async {
    try {
      final platformVersion = await DeviceInformation.platformVersion;
      final imeiNo = await DeviceInformation.deviceIMEINumber;
      final modelName = await DeviceInformation.deviceModel;
      final manufacturerName = await DeviceInformation.deviceManufacturer;
      final apiLevel = await DeviceInformation.apiLevel;
      final deviceName = await DeviceInformation.deviceName;
      final productName = await DeviceInformation.productName;
      final cpuType = await DeviceInformation.cpuName;
      final hardware = await DeviceInformation.hardware;

      if (!mounted) return;

      setState(() {
        _platformVersion = "Running on :$platformVersion";
        _imeiNo = 'IMEI num: $imeiNo';
        _modelName = modelName;
        _manufacturerName = manufacturerName;
        _apiLevel = apiLevel;
        _deviceName = deviceName;
        _productName = productName;
        _cpuType = cpuType;
        _hardware = hardware;
      });
    } on PlatformException catch (e) {
      setState(() {
        _platformVersion = '${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Information Plugin Example app'),
      ),
      body: DeviceInfoDisplay(
        platformVersion: _platformVersion,
        imeiNo: _imeiNo,
        modelName: _modelName,
        apiLevel: _apiLevel,
        manufacturerName: _manufacturerName,
        deviceName: _deviceName,
        productName: _productName,
        cpuType: _cpuType,
        hardware: _hardware,
      ),
    );
  }
}

class DeviceInfoDisplay extends StatelessWidget {
  final String platformVersion;
  final String imeiNo;
  final String modelName;
  final dynamic apiLevel;
  final String manufacturerName;
  final String deviceName;
  final String productName;
  final String cpuType;
  final String hardware;

  DeviceInfoDisplay({
    required this.platformVersion,
    required this.imeiNo,
    required this.modelName,
    required this.apiLevel,
    required this.manufacturerName,
    required this.deviceName,
    required this.productName,
    required this.cpuType,
    required this.hardware,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text('$platformVersion\n'),
          SizedBox(height: 10),
          Text('IMEI Number: $imeiNo\n'),
          SizedBox(height: 10),
          Text('Device Model: $modelName\n'),
          SizedBox(height: 10),
          Text('API Level: $apiLevel\n'),
          SizedBox(height: 10),
          Text('Manufacturer Name: $manufacturerName\n'),
          SizedBox(height: 10),
          Text('Device Name: $deviceName\n'),
          SizedBox(height: 10),
          Text('Product Name: $productName\n'),
          SizedBox(height: 10),
          Text('CPU Type: $cpuType\n'),
          SizedBox(height: 10),
          Text('Hardware Name: $hardware\n'),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
