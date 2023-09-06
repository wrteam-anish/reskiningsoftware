import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static Future<File> assetToFile(String assetPath) async {
    // Read the contents of the asset as a List<int>.

    List<int> assetData =
        await rootBundle.load(assetPath).then((ByteData data) {
      return data.buffer.asUint8List();
    });

    // Get a temporary directory on the device to store the file.
    var tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    // log(Directory('$tempPath/struc').listSync().toString());
    // Create a temporary file and write the asset data to it.
    File file = await File('$tempPath/struc').create();
    await file.writeAsBytes(assetData);

    // Return the temporary file.
    return file;
  }

  static storagePermmision() async {
    if (Platform.isMacOS) {
      return;
    }
    const permission = Permission.storage;
    final status = await permission.status;
    debugPrint('>>>Status $status');

    /// here it is coming as PermissionStatus.granted
    await Permission.manageExternalStorage.request();

    ///
    if (status != PermissionStatus.granted) {
      await permission.request();

      if (await permission.status.isGranted) {
      } else {
        await permission.request();
      }
      debugPrint('>>> ${await permission.status}');
    }
  }
}
