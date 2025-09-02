import 'dart:convert';

import 'package:archive/archive_io.dart';

class ZipUtils {
  static Future<void> writeToArchive(
    Archive archive,
    Map<String, String> contents,
  ) async {
    contents.forEach((fileName, content) {
      final bytes = utf8.encode(content);
      final archiveFile = ArchiveFile(fileName, bytes.length, bytes);
      archiveFile.compressionLevel = DeflateLevel.bestSpeed;
      archive.addFile(archiveFile);
    });
  }
}
