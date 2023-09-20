import 'dart:io';

abstract class DataType<T> {
  abstract final T content;
}

class TextType extends DataType<String> {
  @override
  final String content;

  TextType(this.content);
}

class TypeFile extends DataType<File> {
  @override
  final File content;

  TypeFile(this.content);
}

class ImageType extends DataType {
  @override
  final dynamic content;

  ImageType(this.content);
}

class ColorType extends DataType<String> {
  @override
  final String content;

  ColorType(this.content);
}
