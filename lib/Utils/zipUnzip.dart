import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:reskinner_new/Listeners/CodeGenerationProcess.dart';
import 'package:reskinner_new/Listeners/errorListener.dart';

class ZipUnzip {
  static Future<void> unzipFile(
      {required File zipFile,
      required String extractToPath,
      bool? logProcess,
      required FutureOr<String> Function(ArchiveFile file)
          currentExtraction}) async {
    try {
      // Read the Zip file from disk.
      final bytes = await zipFile.readAsBytes();
      // Decode the Zip file
      final Archive archive = ZipDecoder().decodeBytes(bytes);
      // Extract the contents of the Zip archive to extractToPath.
      int curr = 0;
      for (final ArchiveFile file in archive) {
        final String filename = file.name;
        if (file.isFile) {
          File filex = File('$extractToPath/$filename')
            ..createSync(recursive: true);
          String rendered = "";

          rendered = await currentExtraction.call(file);
          await Future.delayed(Duration(milliseconds: 0));

          filex.writeAsBytesSync(rendered.codeUnits);
          curr++;

          // var fileOutof = "$curr/${archive.numberOfFiles()}";
          var fileOutof = {
            "current": curr,
            "total": archive.numberOfFiles(),
          };
          await Future.delayed(const Duration(milliseconds: 10));

          if (logProcess != false) {
            if (curr == archive.numberOfFiles()) {
              TerminalProcess.addValue({
                "fileName": "Done",
                "outOf": fileOutof,
                "file": "",
                "status": "DONE",
                "type": ConsoleProcessType.codeGeneration,
              });
            } else {
              TerminalProcess.addValue({
                "fileName": filename,
                "outOf": fileOutof,
                "file": filename,
                "status": "PROGRESS",
                "type": ConsoleProcessType.codeGeneration,
              });
              // Notifiers.unzipingFile.value = {
              //   "fileName": filename,
              //   "outOf": fileOutof
              // };
            }
          }
        } else {
          // it should be a directory
          Directory('$extractToPath/$filename').create(recursive: true);
          curr++;
        }
      }
    } catch (e, st) {
      Errors.error(e.toString());
      log("Something wrong while zip $st");
    }
  }
}
