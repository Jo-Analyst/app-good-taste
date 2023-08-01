import 'package:app_good_taste/app/controllers/production_controller.dart';
import 'package:app_good_taste/app/pages/production_details_list_page.dart';
import 'package:app_good_taste/app/template/slide_year.dart';
import 'package:app_good_taste/app/utils/month.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllProductionsPage extends StatefulWidget {
  const AllProductionsPage({super.key});

  @override
  State<AllProductionsPage> createState() => _AllProductionsPageState();
}

class _AllProductionsPageState extends State<AllProductionsPage> {
  List<Map<String, dynamic>> date = Month.listMonths.map((dt) {
    return {
      "number": dt["number"],
      "month": dt["month"],
      "there_is_production": false
    };
  }).toList();

  String yearSelected = "";
  bool confirmUpdateAndDelete = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      yearSelected = DateTime.now().year.toString();
    });
    changeDateList();
  }

  Future<bool> getDateProductions(String dateSelected) async {
    final productionController =
        Provider.of<ProductionController>(context, listen: false);
    final dateProductions = await productionController.loadDate(dateSelected);
    return dateProductions.isNotEmpty;
  }

  void openScreen(int index) async {
    final confirmUpdateAndDelete = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductionDetailsListPage(
          monthAndYear: "${date[index]["number"]}/$yearSelected",
          nameMonth: date[index]["month"],
        ),
      ),
    );
    if (confirmUpdateAndDelete == true) {
      setState(() {
        this.confirmUpdateAndDelete = true;
      });
      getDateProductions("${date[index]["number"]}/$yearSelected");
      changeDateList();
    }
  }

  changeDateList() async {
    for (var dt in date) {
      bool thereIsProduction =
          await getDateProductions("${dt["number"]}/$yearSelected");
      setState(() {
        dt["there_is_production"] = thereIsProduction;
      });
    }
  }

  void closeScreen() {
    Navigator.of(context).pop(confirmUpdateAndDelete);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        closeScreen();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
            margin: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () => closeScreen(),
              icon: const Icon(
                Icons.close,
                size: 35,
              ),
            ),
          ),
          title: const Text(
            "Buscar por data",
          ),
          toolbarHeight: 100,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(179, 246, 245, 245),
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    "Escolha o ano e o mês:",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    height: 3,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 30,
                      ),
                      SlideYear(onChangedDate: (date) {
                        setState(() {
                          yearSelected = date.toString();
                          changeDateList();
                        });
                      }),
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    height: 3,
                  ),
                  const SizedBox(height: 5),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    children: List.generate(
                      date.length,
                      (index) {
                        return InkWell(
                          onTap: date[index]["there_is_production"]
                              ? () => openScreen(index)
                              : null,
                          child: Card(
                            elevation: 8,
                            child: Container(
                              decoration: date[index]["there_is_production"]
                                  ? BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color.fromARGB(
                                              255, 19, 83, 135),
                                          Theme.of(context).primaryColor,
                                        ],
                                      ),
                                    )
                                  : null,
                              color: date[index]["there_is_production"]
                                  ? null
                                  : Colors.black54,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${date[index]["number"]}',
                                    style: const TextStyle(
                                      fontFamily: "YesevaOne",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${date[index]["month"]}',
                                    style: const TextStyle(
                                      fontFamily: "YesevaOne",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
