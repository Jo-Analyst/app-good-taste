import 'package:app_good_taste/app/controllers/production_controller.dart';
import 'package:app_good_taste/app/pages/production_details_page.dart';
import 'package:app_good_taste/app/template/pdf_generator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/load_details_productions.dart';

class ProductionDetailsListPage extends StatefulWidget {
  final String monthAndYear;
  final String nameMonth;
  const ProductionDetailsListPage(
      {required this.monthAndYear, required this.nameMonth, super.key});

  @override
  State<ProductionDetailsListPage> createState() =>
      _ProductionDetailsListPage();
}

class _ProductionDetailsListPage extends State<ProductionDetailsListPage> {
  List<Map<String, dynamic>> productionDetailsListPage = [];
  double valueProfit = 0, valueEntry = 0, valueLeave = 0;
  List<Map<String, dynamic>> itemsEntry = [], itemsLeave = [];

  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  bool result = false;
  String monthAndYear = "";
  String date = "";
  @override
  void initState() {
    super.initState();
    monthAndYear = widget.monthAndYear;
    loadProductionDetailsListPage();
    loadDetailsProductions();
  }

  void loadProductionDetailsListPage() async {
    final productionController =
        Provider.of<ProductionController>(context, listen: false);
    final productions = await productionController.loadDate(monthAndYear);
    setState(() {
      productionDetailsListPage = productions;
    });
  }

  void loadDetailsProductions() {
    getSumValueProfit();
    getSumValueEntry();
    getSumValueLeave();
    getSumQuantityAndValueEntry();
    getSumPriceFeedstockAndCountFeedstockAndValueLeave();
  }

  void getSumPriceFeedstockAndCountFeedstockAndValueLeave() async {
    itemsLeave = await LoadDetailsProductions
        .getSumPriceFeedstockAndCountFeedstockAndValueLeave(
            context, monthAndYear);
    setState(() {});
  }

  void getSumQuantityAndValueEntry() async {
    itemsEntry = await LoadDetailsProductions.getSumQuantityAndValueEntry(
        context, monthAndYear);
    setState(() {});
  }

  void getSumValueEntry() async {
    final getSumValueEntry =
        await LoadDetailsProductions.getSumValueEntry(context, monthAndYear);
    setState(() {
      valueEntry = getSumValueEntry[0]["value_entry"] == null
          ? 0.0
          : getSumValueEntry[0]["value_entry"] as double;
    });
  }

  void getSumValueLeave() async {
    final getSumValueLeave =
        await LoadDetailsProductions.getSumValueLeave(context, monthAndYear);
    setState(() {
      valueLeave = getSumValueLeave[0]["value_leave"] == null
          ? 0.0
          : getSumValueLeave[0]["value_leave"] as double;
    });
  }

  void getSumValueProfit() async {
    final getSumValueProfit =
        await LoadDetailsProductions.getSumValueProfit(context, monthAndYear);
    setState(() {
      valueProfit = getSumValueProfit[0]["value_profit"] == null
          ? 0.0
          : getSumValueProfit[0]["value_profit"] as double;
    });
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      productionDetailsListPage.sort((a, b) {
        final aValue = a.values.toList()[columnIndex];
        final bValue = b.values.toList()[columnIndex];

        if (aValue is String && bValue is String) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        } else if (aValue is num && bValue is num) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        }

        return 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(result);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Produção - Mês de ${widget.nameMonth}",
            style: const TextStyle(fontSize: 18),
          ),
          toolbarHeight: 100,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(result),
            icon: const Icon(
              Icons.close,
              size: 35,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () async {
                  final productionProvider =
                      Provider.of<ProductionController>(context, listen: false);
                  final productionDetails = await productionProvider
                      .getSumQuantityAndValueEntry(widget.monthAndYear);
                  generateAndSharePDF(productionDetails, monthAndYear,
                      valueEntry, itemsLeave, valueLeave, valueProfit);
                },
                icon: const Icon(
                  Icons.share_sharp,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          child: productionDetailsListPage.isEmpty
              ? const Center(
                  child: Text(
                    "Sem dados a exibir...",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        color: Colors.white,
                        margin: const EdgeInsets.all(10),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.maxWidth),
                          child: DataTable(
                            columns: [
                              DataColumn(
                                label: const Text("Data"),
                                onSort: (columnIndex, ascending) {
                                  _onSort(columnIndex, ascending);
                                },
                              ),
                              DataColumn(
                                label: const Text("V. Entrada"),
                                onSort: (columnIndex, ascending) {
                                  _onSort(columnIndex, ascending);
                                },
                              ),
                              DataColumn(
                                label: const Text("V. Saída"),
                                onSort: (columnIndex, ascending) {
                                  _onSort(columnIndex, ascending);
                                },
                              ),
                              DataColumn(
                                label: const Text("Lucro"),
                                onSort: (columnIndex, ascending) {
                                  _onSort(columnIndex, ascending);
                                },
                              ),
                              DataColumn(
                                label: const Text("+ Detalhes"),
                                onSort: (columnIndex, ascending) {
                                  _onSort(columnIndex, ascending);
                                },
                              ),
                            ]
                                .map(
                                  (column) => DataColumn(
                                    label: column.label,
                                    onSort: column.onSort,
                                    numeric: column.numeric,
                                    tooltip: column.tooltip,
                                    // Adicione a propriedade flex:
                                  ),
                                )
                                .toList(),
                            rows: productionDetailsListPage
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final data = entry.value;
                              final isEvenRow = index % 2 == 0;
                              final rowColor =
                                  isEvenRow ? Colors.white : Colors.grey[200];

                              return DataRow(
                                color:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return rowColor?.withOpacity(
                                        0.5); // Opacidade reduzida quando a linha estiver selecionada
                                  } else {
                                    return rowColor;
                                  }
                                }),
                                cells: [
                                  DataCell(
                                    Text(data['date']),
                                  ),
                                  DataCell(
                                    Text(
                                      NumberFormat("R\$ #0.00", "PT-BR")
                                          .format(data['value_entry']),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      NumberFormat("R\$ #0.00", "PT-BR")
                                          .format(data['value_leave']),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      NumberFormat("R\$ #0.00", "PT-BR")
                                          .format(data['value_profit']),
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      onPressed: () async {
                                        final result =
                                            await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ProductionDetailsPage(
                                              date: data['date'],
                                              valueEntry: data["value_entry"],
                                              valueLeave: data["value_leave"],
                                              valueProfit: data["value_profit"],
                                            ),
                                          ),
                                        );

                                        if (result == null) return;
                                        if (result[0] == true) {
                                          setState(() {
                                            this.result = true;
                                            monthAndYear = result[1]
                                                .toString()
                                                .substring(3, 10);
                                          });
                                          loadProductionDetailsListPage();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.add_chart_sharp,
                                        size: 35,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
        ),
      ),
    );
  }
}
