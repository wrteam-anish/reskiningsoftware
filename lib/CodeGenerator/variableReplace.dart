import 'package:mustachex/mustachex.dart';

import '../Data/dataTypes.dart';

class VariableReplaceTask {
  Future<String> replace(List<int> data, Map<String, DataType> storage) async {
    Map<String, dynamic> variables =
        storage.map((key, value) => MapEntry(key, value.content));
    String fileData = String.fromCharCodes(data);
    MustachexProcessor processor = MustachexProcessor(
      initialVariables: variables,
      missingVarFulfiller: (variable) {
        return "";
      },
    );

    return await processor.process(fileData);
  }
}
