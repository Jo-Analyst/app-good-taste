import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductionDetails extends StatelessWidget {
  const ProductionDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> productionDetails = [
      {
        "date": "11/07/2023",
        "value-entry": 40,
        "value-leave": 20,
        "profit": 20
      },
      {
        "date": "11/07/2023",
        "value-entry": 40,
        "value-leave": 20,
        "profit": 20
      },
      {
        "date": "11/07/2023",
        "value-entry": 40,
        "value-leave": 20,
        "profit": 20
      },
      {
        "date": "11/07/2023",
        "value-entry": 40,
        "value-leave": 20,
        "profit": 20
      },
      {
        "date": "11/07/2023",
        "value-entry": 40,
        "value-leave": 20,
        "profit": 20
      },
      {
        "date": "11/07/2023",
        "value-entry": 40,
        "value-leave": 20,
        "profit": 20
      },
      {
        "date": "12/07/2023",
        "value-entry": 30,
        "value-leave": 10,
        "profit": 20
      },
      {
        "date": "16/07/2023",
        "value-entry": 50,
        "value-leave": 25,
        "profit": 25
      },
      {
        "date": "17/07/2023",
        "value-entry": 60,
        "value-leave": 30,
        "profit": 30
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalhes das produções",
          style: TextStyle(fontSize: 25),
        ),
        toolbarHeight: 100,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.close,
            size: 35,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          child: DataTable(
            columns: const [
              DataColumn(label: Text("Data")),
              DataColumn(label: Text("V. E")),
              DataColumn(label: Text("V. S")),
              DataColumn(label: Text("Lucro")),
            ],
            rows: productionDetails.map((data) {
              return DataRow(
                cells: [
                  DataCell(Text(data['date'])),
                  DataCell(Text(NumberFormat("R\$ #0.00", "PT-BR")
                      .format(data['value-entry']))),
                  DataCell(Text(NumberFormat("R\$ #0.00", "PT-BR")
                      .format(data['value-leave']))),
                  DataCell(Text(NumberFormat("R\$ #0.00", "PT-BR")
                      .format(data['profit']))),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
