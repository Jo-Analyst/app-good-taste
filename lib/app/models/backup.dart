import 'dart:io';

import 'package:share/share.dart';

class Backup {
  static String pathStorage = '/storage/emulated/0/Bom Sabor';
  static String pathDB =
      '/data/user/0/com.example.app_good_taste/databases/goodtaste.db';

  static Future<String?> toGenerate() async {
    try {
      File ourDbFile = File(pathDB);

      Directory? folderPathForDbFile = Directory(pathStorage);
      await folderPathForDbFile.create();
      await ourDbFile.copy("$pathStorage/goodtaste.db");

      Share.shareFiles(["$pathStorage/goodtaste.db"],
          text: "Backup concluído!");
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  static Future<String?> restore() async {
    try {
      File saveDBFile = File("$pathStorage/goodtaste.db");

      await saveDBFile.copy(pathDB);
    } catch (e) {
      return e.toString();
    }
    return null;
  }
}
