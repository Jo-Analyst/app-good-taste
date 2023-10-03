import 'package:app_good_taste/app/controllers/production_controller.dart';
import 'package:app_good_taste/app/pages/all_productions_page.dart';
import 'package:app_good_taste/app/pages/production_page.dart';
import 'package:app_good_taste/app/template/pdf_generator.dart';
import 'package:app_good_taste/app/utils/load_details_productions.dart';
import 'package:app_good_taste/app/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:app_good_taste/app/template/movement_details_template.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../template/slide_month.dart';

class MovementDetailsPage extends StatefulWidget {
  const MovementDetailsPage({super.key});

  @override
  State<MovementDetailsPage> createState() => _MovementDetailsPageState();
}

class _MovementDetailsPageState extends State<MovementDetailsPage> {
  double valueProfit = 0, valueEntry = 0, valueLeave = 0;
  String monthAndYear = "", year = "";
  List<Map<String, dynamic>> itemsEntry = [],
      itemsLeave = [],
      productionDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    String currentMonth = currentDate.month.toString().padLeft(2, '0');
    setState(() {
      year = currentDate.year.toString();
      monthAndYear = "/$currentMonth/$year";
    });

    loadDetailsProductions();
  }

  void getDetailsProductions() async {
    final productionProvider =
        Provider.of<ProductionController>(context, listen: false);
    final production = await productionProvider
        .getSumQuantityAndValueEntry("${monthAndYear.split("/")[1]}/$year");
    setState(() {
      productionDetails = production;
    });
  }

  void loadDetailsProductions() {
    getSumValueProfit();
    getSumValueEntry();
    getSumValueLeave();
    getSumQuantityAndValueEntry();
    getSumPriceFeedstockAndCountFeedstockAndValueLeave();
    getDetailsProductions();
    setState(() {
      isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: Visibility(
          visible: productionDetails.isNotEmpty,
          child: FloatingActionButton(
            heroTag: null,
            mini: true,
            onPressed: () => generateAndSharePDF(
                productionDetails,
                "${monthAndYear.split("/")[1]}/$year",
                valueEntry,
                itemsLeave,
                valueLeave,
                valueProfit),
            child: const Icon(
              Icons.share,
              size: 30,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: loading(context, 50),
            )
          : Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 28),
                      SlideMonth(
                        getNumberMonth: (numberMonth) {
                          setState(() {
                            monthAndYear = "/$numberMonth/$year";
                          });
                          loadDetailsProductions();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            MovementDetailsTemplate(
                              price: valueEntry,
                              description: "Entrada",
                              items: itemsEntry,
                            ),
                            MovementDetailsTemplate(
                              price: valueLeave,
                              description: "Saída",
                              items: itemsLeave,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 90,
                  left: MediaQuery.of(context).size.width / 2 - 125,
                  width: 250,
                  child: Card(
                    elevation: 6,
                    // shadowColor: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lucro Total',
                            style: TextStyle(fontSize: 18),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    NumberFormat("R\$ #0.00", "PT-BR")
                                        .format(valueProfit),
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.pink.shade500,
                                ),
                                iconSize: 30,
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem(
                                    padding: EdgeInsets.zero,
                                    value: "production-of-the-day",
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        Text("Adicionar Produção"),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: "all-productions",
                                    padding: EdgeInsets.zero,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.zoom_in,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Acessar Produções",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (option) async {
                                  if (option == "production-of-the-day") {
                                    final confirmSave = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ProductionPage(
                                          production: {},
                                          listFeedstock: [],
                                          isEdition: false,
                                        ),
                                      ),
                                    );

                                    if (confirmSave[0] == true) {
                                      loadDetailsProductions();
                                    }
                                  } else if (option == "all-productions") {
                                    final confirmUpdateAndDelete =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const AllProductionsPage(),
                                      ),
                                    );
                                    if (confirmUpdateAndDelete == true) {
                                      loadDetailsProductions();
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
