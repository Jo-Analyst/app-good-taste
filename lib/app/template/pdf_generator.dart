import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

Future<void> generateAndSharePDF(
    List<Map<String, dynamic>> productionDetails, String monthAndYear) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            children: [
              pw.Text(
                "Balanço - CHUP-CHUP - $monthAndYear",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                data: <List<String>>[
                  <String>["Sabor", "Quantidade", "Preço", "Entrada"],
                  ...productionDetails.map(
                    (production) => [
                      production["name"],
                      production["quantity"].toString(),
                      NumberFormat("R\$ #0.00", "pt-br")
                          .format(production["price"]),
                      NumberFormat("R\$ #0.00", "pt-br")
                          .format(production["value_entry"]),
                    ],
                  ),
                ],
                cellAlignment: pw.Alignment.center,
              )
            ],
          ),
        );
      },
    ),
  );

  final status = await Permission.storage.request();
  if (status.isGranted) {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/balancete.pdf");
    await file.writeAsBytes(await pdf.save());

    Share.shareFiles([file.path], text: "Confira meu PDF!");
  } else {
    // O usuário negou a permissão
    print("Permissão de armazenamento negada.");
  }
}
