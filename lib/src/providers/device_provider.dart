import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

class DeviceProvider {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _mapper = new Map();
  Map<String, dynamic> get mapper => _mapper;

  final _deviceStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Function(Map<String, dynamic>) get deviceSink =>
      _deviceStreamController.sink.add;

  Stream<Map<String, dynamic>> get deviceStream =>
      _deviceStreamController.stream;

  DeviceProvider() {
    initPlatformState();
  }

  initPlatformState() async {
    try {
      _mapper = (Platform.isAndroid)
          ? _readAndroidBuildData(await deviceInfoPlugin.androidInfo)
          : _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      deviceSink(_mapper);
    } on PlatformException {
      _mapper = <String, dynamic>{'Error:': 'Failed to get platform version.'};
      deviceSink(_mapper);
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  void dispose() {
    _deviceStreamController?.close();
  }
}
