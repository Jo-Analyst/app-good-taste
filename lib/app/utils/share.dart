import 'package:app_good_taste/app/utils/path.dart';
import 'package:share/share.dart';

class ShareUtils {
  static void share() {
    Share.shareFiles(
      ["/$pathStorage/goodtaste.db"],
      text: "Backup concluído!",
    );
  }
}
