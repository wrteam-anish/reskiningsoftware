import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:reskinner_new/Listeners/CodeGenerationProcess.dart';
import 'package:reskinner_new/Listeners/appRunListener.dart';
import 'package:reskinner_new/Utils/zipUnzip.dart';

import '../CodeGenerator/generator.dart';
import '../settings.dart';

class AppRunner {
  static String workingDirectory = "";
  static Process? process;

  static String selectedDeviceId = "";

  static runApp() async {
    AppRunListener.setStatus(AppRunStatus.starting);
    log("SELECTED DEVICE ID $selectedDeviceId $workingDirectory");
    process = await Process.start(
      "flutter",
      ["run", "-d", selectedDeviceId],
      workingDirectory: workingDirectory,
    );

    ///Listen error
    process?.stderr.listen((event) {});
    process?.stdout.listen((event) {
      // processStatus.value = "Running";
      Map process = TerminalProcess.get().value;
      List logs = process['logs'] ?? [];
      logs.add(String.fromCharCodes(event));
      TerminalProcess.addValue({"logs": logs});
      if (String.fromCharCodes(event).contains("A Dart VM Service on")) {
        AppRunListener.setStatus(AppRunStatus.started);
      }
      if (String.fromCharCodes(event).contains("Restarted application")) {
        AppRunListener.setStatus(AppRunStatus.started);
      }
      if (String.fromCharCodes(event).contains("Reloaded") &&
          String.fromCharCodes(event).contains("libraries")) {
        AppRunListener.setStatus(AppRunStatus.started);
      }
    });

    int? exitCode = await process?.exitCode;
    if (exitCode == 0) {
      // AppRunListener.setStatus(AppRunStatus.started);
      AppRunListener.setStatus(AppRunStatus.initial);
    } else {
      AppRunListener.setStatus(AppRunStatus.failed);
    }
  }

  static void killApp() {
    process!.stdin.add("q".codeUnits);
    process?.kill();
  }

  static hotRestart() {
    if (process != null) {
      AppRunListener.setStatus(AppRunStatus.restarting);
      process!.stdin.add("R".codeUnits);
    }
  }

  static hotReload() {
    if (process != null) {
      AppRunListener.setStatus(AppRunStatus.reloading);
      process!.stdin.add("r".codeUnits);
    }
  }

  static pubGet() async {
    await Process.start(
      "flutter",
      [
        "pub",
        "get",
      ],
      workingDirectory: workingDirectory,
    ).then((value) {
      value.stdout.listen((event) {
        log("--${String.fromCharCodes(event)}");
        // processStatus.value = "Running";
        Map process = TerminalProcess.get().value;
        List logs = process['logs'] ?? [];
        logs.add(String.fromCharCodes(event));
        TerminalProcess.addValue({"logs": logs});

        if (String.fromCharCodes(event).contains("Restarted application")) {
          // hotRestartStatus.value = "Restarted";
        }
      });
    });
  }

  static generationFolder() async {
    Directory directory = await getTemporaryDirectory();
    Directory folderForAppGenerate = Directory(
      "${directory.path}/folderForAppGenerate",
    );
    await folderForAppGenerate.create(recursive: true);
    workingDirectory =
        "${folderForAppGenerate.path}/${Settings.selfFolderName}/";

    await ZipUnzip.unzipFile(
      logProcess: false,
      zipFile: Generator.generated!,
      extractToPath: folderForAppGenerate.path,
      currentExtraction: (file) {
        var data = file.content as List<int>;
        var rendered = String.fromCharCodes(data);
        return rendered;
      },
    );
  }
}
