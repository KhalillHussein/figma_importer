import 'dart:io';

class FileUtils {
  static void createDir(String directory) {
    Directory(directory).createSync(recursive: true);
  }

  static String readFile(String filePath) {
    final file = File(filePath);
    assert(file.existsSync(), "filePath $filePath doesn't exist");
    final content = file.readAsStringSync();
    return content;
  }

  static void writeToFile(String filePath, String content) {
    final file = File(filePath);
    if (!file.existsSync()) {
      file.createSync();
    }
    file.writeAsStringSync(content);
  }
}
