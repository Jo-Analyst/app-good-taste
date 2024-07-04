import 'dart:io';
import 'package:app_good_taste/app/utils/permission_use_app.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

Future<void> generateAndSharePDF(
    List<Map<String, dynamic>> productionDetails,
    String monthAndYear,
    double valueEntry,
    List<Map<String, dynamic>> feedstockDetails,
    double valueLeave,
    double valueProfit) async {
  final pdf = pw.Document();

  final pdfData = <pw.Widget>[
    pw.Center(
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
          pw.Align(
            alignment: pw.Alignment.topRight,
            child: pw.TableHelper.fromTextArray(
              data: <List<String>>[
                ["SABORES"]
              ],
              cellAlignment: pw.Alignment.center,
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
    pw.TableHelper.fromTextArray(
      data: <List<String>>[
        <String>[
          "Sabor",
          "Preço",
          "Quantidade",
          "Subtotal",
        ],
        ...productionDetails.map(
          (production) => [
            production["name"],
            NumberFormat("R\$ #0.00", "pt-br")
                .format(production["price_product"]),
            production["quantity"].toString(),
            NumberFormat("R\$ #0.00", "pt-br").format(production["subtotal"]),
          ],
        ),
      ],
      cellAlignment: pw.Alignment.center,
    ),
    pw.TableHelper.fromTextArray(
      data: <List<String>>[
        [
          "Valor total: ${NumberFormat("R\$ #0.00", "pt-br").format(valueEntry)}"
        ]
      ],
      cellAlignment: pw.Alignment.centerRight,
    ),
    pw.SizedBox(height: 20),
    pw.Align(
      alignment: pw.Alignment.topRight,
      child: pw.TableHelper.fromTextArray(
        data: <List<String>>[
          ["Gastos"]
        ],
        cellAlignment: pw.Alignment.center,
        headerStyle: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ),
    pw.TableHelper.fromTextArray(
      data: <List<String>>[
        <String>[
          "Matéria prima",
          "Unidade de medida",
          "Preço",
          "Quantidade",
          "Subtotal"
        ],
        ...feedstockDetails.map(
          (feedstock) => [
            feedstock["name"],
            feedstock["unit"],
            NumberFormat("R\$ #0.00", "pt-br")
                .format(feedstock["price_feedstock"]),
            feedstock["quantity"].toString(),
            NumberFormat("R\$ #0.00", "pt-br").format(feedstock["subtotal"]),
          ],
        ),
      ],
      cellAlignment: pw.Alignment.center,
    ),
    pw.TableHelper.fromTextArray(
      data: <List<String>>[
        [
          "Valor total: ${NumberFormat("R\$ #0.00", "pt-br").format(valueLeave)}"
        ]
      ],
      cellAlignment: pw.Alignment.centerRight,
    ),
    pw.Table(
      children: [
        pw.TableRow(
          children: [
            pw.Container(
              margin: const pw.EdgeInsets.only(top: 10),
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Lucro Total: ${NumberFormat("R\$ #0.00", "pt-br").format(valueProfit)}",
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ];

  const maxElementsPerPage =
      20; // Defina o número máximo de elementos por página

  for (var i = 0; i < pdfData.length; i += maxElementsPerPage) {
    final endIndex = (i + maxElementsPerPage < pdfData.length)
        ? i + maxElementsPerPage
        : pdfData.length;

    final sublist = pdfData.sublist(i, endIndex);
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => sublist,
      ),
    );
  }

  final isGranted = await isGrantedRequestPermissionStorage();
  if (isGranted) {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/balancete.pdf");
    await file.writeAsBytes(await pdf.save());

    Share.shareFiles([file.path], text: "Confira meu PDF!");
  }
}
