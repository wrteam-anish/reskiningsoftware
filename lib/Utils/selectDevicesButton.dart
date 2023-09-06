import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../Screen/Widget/customDialogs.dart';

class SelectDevicesButtonWidget extends StatefulWidget {
  final Function(Map device) onSelect;
  const SelectDevicesButtonWidget({
    Key? key,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<SelectDevicesButtonWidget> createState() =>
      _SelectDevicesButtonWidgetState();
}

class _SelectDevicesButtonWidgetState extends State<SelectDevicesButtonWidget> {
  String lable = "Select Device";
  String selectedDeviceId = "";
  Future<List<Map<String, String>?>> getFlutterDeviceList() async {
    ProcessResult processResult = await Process.run("flutter", ["devices"]);
    String result = processResult.stdout;
    var splitDevicesRawString = result.splitMapJoin(
      RegExp("\n"),
      onMatch: (p0) {
        return "+${p0.group(0)!}+";
      },
      onNonMatch: (p0) {
        return p0;
      },
    );
    log("SPLITTED $splitDevicesRawString");
    List<String> devicesWithIdentifier = splitDevicesRawString.split("+");
    log("SPLITTE---D $devicesWithIdentifier");

    devicesWithIdentifier.removeWhere((element) => element.trim() == "");
    List<Map<String, String>?> deviceMap = devicesWithIdentifier.map(
      (device) {
        bool contains = device.contains("•");
        if (contains) {
          List<String> deviceValue = device.split("•");
          return {
            "name": deviceValue.first.trim(),
            "id": deviceValue[1].trim()
          };
        }
      },
    ).toList();
    deviceMap.removeWhere((element) => element == null);
    return deviceMap;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        List<Map<String, String>?> devices = await getFlutterDeviceList();
        List<Map<String, String?>> map = devices.map((e) {
          return {"title": e!['name'], "value": e['id']};
        }).toList();
        Future.delayed(
          Duration.zero,
          () async {
            var selected = await showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return CustomDialoges.showPickerDialoge(
                      itemList: map, selectedValue: selectedDeviceId);
                });
            selectedDeviceId = selected['value'];
            lable = selected['title'];
            widget.onSelect.call(selected);
            setState(() {});
          },
        );
      },
      child: Text(lable),
    );
  }
}

class DeviceSelector {
  final BuildContext context;
  final String initialDeviceName;
  final Function(Map selected) onSelect;
  dynamic selectedDeviceId = "";
  static List<Map<String, String>?> availableDevices = [];
  static Future<List<Map<String, String>?>> getFlutterDeviceList() async {
    ProcessResult processResult = await Process.run("flutter", ["devices"]);
    String result = processResult.stdout;
    var splitDevicesRawString = result.splitMapJoin(
      RegExp("\n"),
      onMatch: (p0) {
        return "+${p0.group(0)!}+";
      },
      onNonMatch: (p0) {
        return p0;
      },
    );
    log("SPLITTED $splitDevicesRawString");
    List<String> devicesWithIdentifier = splitDevicesRawString.split("+");
    log("SPLITTE---D $devicesWithIdentifier");

    devicesWithIdentifier.removeWhere((element) => element.trim() == "");
    List<Map<String, String>?> deviceMap = devicesWithIdentifier.map(
      (device) {
        bool contains = device.contains("•");
        if (contains) {
          List<String> deviceValue = device.split("•");
          return {
            "name": deviceValue.first.trim(),
            "id": deviceValue[1].trim()
          };
        }
      },
    ).toList();
    deviceMap.removeWhere((element) => element == null);
    availableDevices = deviceMap;
    return deviceMap;
  }

  select() async {
    List<Map<String, String>?> devices =
        availableDevices; //await getFlutterDeviceList();
    List<Map<String, String?>> map = devices.map((e) {
      return {"title": e!['name'], "value": e['id']};
    }).toList();
    Future.delayed(Duration.zero, () async {
      var selected = await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return CustomDialoges.showPickerDialoge(
                itemList: map, selectedValue: selectedDeviceId);
          });
      onSelect.call(selected);
    });
  }
  // selectedDeviceId = selected['value'];
  // lable = selected['title'];
  // widget.onSelect.call(selected);
  // setState(() {});

  DeviceSelector(this.context, this.initialDeviceName, this.selectedDeviceId,
      {required this.onSelect});
}
