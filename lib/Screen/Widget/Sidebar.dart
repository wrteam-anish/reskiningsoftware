import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reskinner_new/Data/data.dart';
import 'package:reskinner_new/Listeners/CodeGenerationProcess.dart';
import 'package:reskinner_new/Utils/lables.dart';

import '../../CodeGenerator/generator.dart';
import 'button.dart';

class SideBar extends StatelessWidget {
  final Function()? onCodegenerationInProgress;
  final Function(String path) onCodeGenerated;
  const SideBar(
      {super.key,
      required this.onCodeGenerated,
      this.onCodegenerationInProgress});

  void _onTapGenerateCode() async {
    var saveLocation = (await getApplicationDocumentsDirectory()).path;

    TerminalProcess.reset();
    await Generator().generateCode(
      Storage.data,
      path: saveLocation,
      onCodegenerationInProgress: () {
        onCodegenerationInProgress?.call();
      },
      onGeneratedPath: (path) {
        log('''GENERATED SUCCESSFUlly''');
        onCodeGenerated.call(path);
      },
    );
  }

  void _onTapLoadConfig() {}
  void _onTapDownloadConfig() {}
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Button(
            icon: Icons.settings,
            title: Lable.generateCode,
            onClick: _onTapGenerateCode,
          ),
          Button(
            icon: Icons.cloud_upload,
            title: Lable.loadConfig,
            onClick: _onTapLoadConfig,
          ),
          Button(
            icon: Icons.download,
            title: Lable.downloadConfig,
            onClick: _onTapDownloadConfig,
          ),
        ],
      ),
    );
  }
}
