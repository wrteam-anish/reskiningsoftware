import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reskinner_new/CodeGenerator/fileByteReplace.dart';
import 'package:reskinner_new/CodeGenerator/variableReplace.dart';
import 'package:reskinner_new/Data/data.dart';
import 'package:reskinner_new/Listeners/errorListener.dart';
import 'package:reskinner_new/Utils/utils.dart';
import 'package:reskinner_new/Utils/zipUnzip.dart';

import '../Data/dataTypes.dart';
import '../settings.dart';

class Generator {
  static File? generated;
  generateCode(Map<String, DataType> data,
      {required String path,
      Function(String path)? onGeneratedPath,
      Function()? onCodegenerationInProgress}) async {
    try {
      ///
      onCodegenerationInProgress?.call();
      File templateFile = await Utils.assetToFile(Settings.templateFilePath);

      ///
      Directory directory = await getApplicationDocumentsDirectory();
//This will unzip at structure folder
      Directory structureFolder =
          Directory("${directory.path}/extractedTemplate");
      await structureFolder.delete(recursive: true);

      await structureFolder.create(recursive: true);

      VariableReplaceTask variableReplaceTask = VariableReplaceTask();
      FileByteReplace fileByteReplace = FileByteReplace();
      ZipUnzip.unzipFile(
        zipFile: templateFile,
        extractToPath: structureFolder.path,
        currentExtraction: (ArchiveFile file) {
          dynamic renderd = String.fromCharCodes(file.content as List<int>);
          String fileName = file.name;
          String fileExtension = fileName.split(".").last;
          List<String> allowedReplaceExtentions =
              Settings.allowedReplaceExtentions;

          bool shouldProcess = !Settings.ignoreContentReplacement
              .contains(fileName.split("/").last);
          log("Processing $fileName");

          if (allowedReplaceExtentions.contains(fileExtension) &&
              shouldProcess) {
            renderd = variableReplaceTask.replace(file.content, Storage.data);
          } else {
            var fileByte = fileByteReplace.replace(Settings.fields, fileName);
            renderd = String.fromCharCodes(fileByte ?? file.content);
          }

          return renderd;
        },
      );

      var generateFileLocation =
          File("$path/${Settings.generatedFileName}.zip");

////If already available then we will delete it
      if (await generateFileLocation.exists()) {
        await generateFileLocation.delete();
      }

      createZipArchive(structureFolder, generateFileLocation);
      generated = generateFileLocation;
      // throw "HEHEH";
      onGeneratedPath?.call(generateFileLocation.path);
    } catch (e) {
      log(e.toString());
      Errors.error(e.toString());
    }
  }

  void createZipArchive(structureFolder, generateFileLocation) {
    // final structureFolder = 'path/to/source/directory';
    // final generateFileLocation = 'path/to/generated/archive.zip';

    Archive archive = Archive();

    // Add all files from the source directory to the archive
    addFilesToArchive(structureFolder, archive);

    // Encode the archive to zip format
    List<int>? zipData = ZipEncoder().encode(archive);

    // Save the zipData to the archive file
    saveZipDataToFile(generateFileLocation, zipData!);
  }

  void addFilesToArchive(Directory directory, Archive archive) {
    List<FileSystemEntity> entities = directory.listSync(recursive: true);
    for (var entity in entities) {
      if (entity is File) {
        String relativePath = entity.path.substring(directory.path.length + 1);
        archive.addFile(ArchiveFile(
            relativePath, entity.lengthSync(), entity.readAsBytesSync()));
      }
    }
  }

  void saveZipDataToFile(File filePath, List<int> zipData) {
    final file = filePath;
    file.writeAsBytesSync(zipData, flush: true);
    print('Zip archive saved to: $filePath');
  }
}
