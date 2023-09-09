import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as m;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reskinner_new/Data/data.dart';
import 'package:reskinner_new/Data/dataTypes.dart';
import 'package:reskinner_new/Listeners/CodeGenerationProcess.dart';
import 'package:reskinner_new/Listeners/errorListener.dart';
import 'package:reskinner_new/Listeners/flutterAvailibility.dart';
import 'package:reskinner_new/Utils/lables.dart';

import '../../CodeGenerator/generator.dart';
import '../../UIGenerator/mainUi.dart';
import '../../settings.dart';
import 'button.dart';

class SideBar extends StatefulWidget {
  final Function()? onCodegenerationInProgress;
  final Function(String path)? onConfigGenerated;
  final Function(String path) onCodeGenerated;
  const SideBar(
      {super.key,
      required this.onCodeGenerated,
      this.onCodegenerationInProgress,
      this.onConfigGenerated});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String generatedPath = "";
  String generatedConfigPath = "";

  @override
  void initState() {
    Process.start("flutter", ["doctor"]).then((Process value) {
      // value.errLines.forEach((element) {
      //   log("EROR  ${element}");
      // });

      value.stdout.forEach((element) {
        bool flutter = String.fromCharCodes(element).contains("Flutter");
        if (flutter) {
          FlutterAvailibility.isAvailable.value = true;
        }
      });
    }).catchError((e) {
      FlutterAvailibility.isAvailable.value = false;
    });
    super.initState();
  }

  void _onTapGenerateCode() async {
    var saveLocation = (await getApplicationDocumentsDirectory()).path;
    TerminalProcess.reset();
    await Generator().generateCode(
      Storage.data,
      path: saveLocation,
      onCodegenerationInProgress: () {
        widget.onCodegenerationInProgress?.call();
      },
      onGeneratedPath: (path) {
        log('''GENERATED SUCCESSFUlly''');
        generatedPath = path;
        widget.onCodeGenerated.call(path);
        setState(() {});
      },
    );
  }

  void _onTapLoadConfig() async {
    try {
      FilePickerResult? filePickerResult =
          await FilePicker.platform.pickFiles(allowMultiple: false);
      Map<String, DataType> filterdData = {};
      if (filePickerResult != null) {
        PlatformFile? pfile = filePickerResult?.files.first;
        File file = File(pfile?.path ?? "");

        String fileText = await file.readAsString();

        var data = json.decode(fileText) as Map;

        if (data.containsKey("--configurationAPP--")) {
          await Future.forEach(data.entries, (entry) async {
            String key = entry.key;
            dynamic value = entry.value;

            List splittedKey = key.toString().split(":");
            String actualKey = splittedKey.first;
            String type = splittedKey.last;

            if (type == "ImageType") {
              var temporaryDirectory = await getTemporaryDirectory();

              try {
                var directory = Directory(
                    "${temporaryDirectory.path}/reskinnnerTempFolder");
                await directory.create(recursive: true);
                File file = File(
                    "${directory.path}/${actualKey}_${m.Random(100).nextInt(10000)}");
                await file.writeAsBytes(List.from(value));
                await file.create(recursive: false);
                filterdData[actualKey] = ImageType(file);
                Storage.data.addAll({actualKey: ImageType(file)});
              } catch (e) {
                log("ISSUE WHILE ADD IAMGE IS $e");
              }
            }

            if (type == "ColorType") {
              String decodedvalue =
                  String.fromCharCodes(Iterable.castFrom(value));
              Storage.data.addAll({actualKey: ColorType(decodedvalue)});

              filterdData[actualKey] = ColorType(decodedvalue);
            }
            if (type == "TypeFile") {
              var temporaryDirectory = await getTemporaryDirectory();
              try {
                var directory = Directory(
                    "${temporaryDirectory.path}/reskinnnerTempFolder");
                await directory.create(recursive: true);
                File file = File(
                    "${directory.path}/${actualKey}_${m.Random(100).nextInt(10000)}");
                await file.writeAsBytes(List.from(value));
                await file.create(recursive: false);
                filterdData[actualKey] = TypeFile(file);
                Storage.data.addAll({actualKey: TypeFile(file)});
              } catch (e) {
                log("ISSUE WHILE ADD IMAGE IS $e");
              }
            }
            if (type == "TextType") {
              String decodedvalue =
                  String.fromCharCodes(Iterable.castFrom(value));
              Storage.data.addAll({actualKey: TextType(decodedvalue)});

              filterdData[actualKey] = TextType(decodedvalue);
            }
          });
        }
        setSettings(Settings.fields, filterdData, 0);
      }
      log("STORAGE IS $filterdData");

      fieldUiState.value = m.Random(0).nextInt(100);
      fieldUiState.notifyListeners();

      setState(() {});
    } catch (e) {
      log("ISSUE IN LOAD CONFIG $e");
    }
  }

  setSettings(List list, Map<String, DataType> data, fieldIndex) {
    for (var i = 0; i < list.length; i++) {
      var field = list[i];
      bool isGroup = field is List;

      if (isGroup) {
        //this field if on zero index so we will pass index and if it increment we will
        setSettings(field, data, i);
      } else {
        try {
          var initialValue = data.entries
              .where(
                (element) {
                  log("DEMO ${element.key} and ${field['fieldPattern']} is Match ${element.key == field['fieldPattern']}");
                  return element.key == field['fieldPattern'];
                },
              )
              .toList()
              .first;

          // log("initVal is ${Settings.fields[i]} ${initialValue.value.content}");

          // log("HERE IS THE  $where");

          if (Settings.fields[fieldIndex] is List) {
            log("ASES ${Settings.fields[fieldIndex][i]}");
            Settings.fields[fieldIndex][i]['initVal'] =
                (initialValue.value.content is File)
                    ? initialValue.value.content.path
                    : initialValue.value.content;
            log("ASES ${Settings.fields[fieldIndex][i]}");
          } else {
            Settings.fields[i]['initVal'] = (initialValue.value.content is File)
                ? initialValue.value.content.path
                : initialValue.value.content;

            log("ASES ${Settings.fields[i]}");
          }
        } catch (e) {
          log("not match at key ${field['fieldPattern']}");
        }
      }
    }
  }

  void _onTapDownloadConfig() async {
    try {
      OpenResult openResult = await OpenFilex.open(generatedConfigPath);
      log(openResult.type.name.toLowerCase());
    } catch (e) {
      Errors.error(e.toString());

      log(e.toString());
    }
  }

  void _onTapGenerateConfig() async {
    Directory? directory = await getApplicationSupportDirectory();
    await directory.create();
    if (directory == null) return;
    File file = File("${directory.path}/config.txt");
    Map<String, dynamic> data = {};
    Storage.data.forEach((key, value) {
      log("key $key and  valye ${value.runtimeType}");

      if (value is TextType) {
        data["$key:TextType"] = value.content.codeUnits;
      } else if (value is TypeFile) {
        data["$key:TypeFile"] = value.content.readAsBytesSync();
      } else if (value is ColorType) {
        data["$key:ColorType"] = value.content.codeUnits;
      } else if (value is ImageType) {
        data["$key:ImageType"] = (value.content as File).readAsBytesSync();
      }
    });

    data['--configurationAPP--'] = "YES";

    file.writeAsStringSync(json.encode(data));
    await file.create(recursive: true);
    generatedConfigPath = file.path;
    widget.onConfigGenerated?.call(file.path);
    setState(() {});
    log("FILE CREATED !!!! ${file.path}");
  }

  void _onTapDownloadCode() async {
    try {
      OpenResult openResult = await OpenFilex.open(generatedPath);
      log(openResult.type.name.toLowerCase());
    } catch (e) {
      Errors.error(e.toString());

      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ValueListenableBuilder(
              valueListenable: FlutterAvailibility.isAvailable,
              builder: (context, value, c) {
                String text = "";
                if (value == true) {
                  text = "Flutter Available";
                } else if (value == false) {
                  text = "Flutter Not available";
                } else {
                  text = "Checking flutter availibility";
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(text),
                );
              }),
          Button(
            icon: Icons.settings,
            title: Lable.generateCode,
            onClick: _onTapGenerateCode,
          ),
          Button(
            icon: Icons.download,
            title: Lable.downloadCode,
            onClick: generatedPath == "" ? null : _onTapDownloadCode,
          ),
          Button(
            icon: Icons.cloud_upload,
            title: Lable.loadConfig,
            onClick: _onTapLoadConfig,
          ),
          Button(
            icon: Icons.file_copy,
            title: Lable.generateConfig,
            onClick: generatedPath == "" ? null : _onTapGenerateConfig,
          ),
          Button(
            icon: Icons.download,
            title: Lable.downloadConfig,
            onClick: generatedConfigPath == "" ? null : _onTapDownloadConfig,
          ),
        ],
      ),
    );
  }
}
