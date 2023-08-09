import 'package:figma_importer/src/parser/parser.dart';

///An Interface class that declares base methods to perform import.
///[T] is the file object that contains styles.
abstract interface class Importer<T> {
  Future<T> getFile();

  Future<Map<StyleDefinition, List<BaseStyle>>> getFileStyles(T file);
}
