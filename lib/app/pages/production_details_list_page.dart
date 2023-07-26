import 'package:app_good_taste/app/controllers/production_controller.dart';
import 'package:app_good_taste/app/pages/production_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductionDetailsListPage extends StatefulWidget {
  final String monthAndYear;
  const ProductionDetailsListPage({required this.monthAndYear, super.key});

  @override
  State<ProductionDetailsListPage> createState() =>
      _ProductionDetailsListPage();
}

class _ProductionDetailsListPage extends State<ProductionDetailsListPage> {
  List<Map<String, dynamic>> productionDetailsListPage = [];

  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  bool confirmUpdateAndDelete = false;
  @override
  void initState() {
    super.initState();
    loadProductionDetailsListPage();
  }

  void loadProductionDetailsListPage() async {
    final productionController =
        Provider.of<ProductionController>(context, listen: false);
    final productions =
        await productionController.loadDate(widget.monthAndYear);
    setState(() {
      productionDetailsListPage = productions;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalhes das produções",
        ),
        toolbarHeight: 100,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(confirmUpdateAndDelete),
          icon: const Icon(
            Icons.close,
            size: 35,
          ),
        ),
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
                                      final confirmUpdateAndDelete =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ProductionDetailsPage(
                                            date: data['date'],
                                            valueEntry: data["value_entry"],
                                            valueLeave: data["value_leave"],
                                            valueProfit: data["value_profit"],
                                          ),
                                        ),
                                      );

                                      if (confirmUpdateAndDelete == true) {
                                        setState(() {
                                          this.confirmUpdateAndDelete = true;
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
    );
  }
}
