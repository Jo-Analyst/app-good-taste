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
  final List<Map<String, dynamic>> date = Month.listMonths;
  String yearSelected = "";

  @override
  void initState() {
    super.initState();
    changeDateList();
    setState(() {
      yearSelected = DateTime.now().year.toString();
    });
  }

  Future<bool> getDateProductions(String dateSelected) async {
    final productionController =
        Provider.of<ProductionController>(context, listen: false);
    final dateProductions = await productionController.loadDate(dateSelected);
    return dateProductions.isNotEmpty;
  }

  void openScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ProductionDetailsListPage(),
      ),
    );
  }

  changeDateList() async {
    for (var dt in date) {
      bool thereIsProduction =
          await getDateProductions("${dt["number"]}/$yearSelected");
      setState(() {
        dt["there_is_production"] = thereIsProduction.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              size: 35,
            ),
          ),
        ),
        title: const Text(
          "Todas as produções",
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
                        onTap: bool.parse(date[index]["there_is_production"])
                            ? () => openScreen()
                            : null,
                        child: Card(
                          elevation: 8,
                          child: Container(
                            decoration: bool.parse(
                                    date[index]["there_is_production"])
                                ? BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color.fromARGB(255, 19, 83, 135),
                                        Theme.of(context).primaryColor,
                                      ],
                                    ),
                                  )
                                : null,
                            color:
                                bool.parse(date[index]["there_is_production"])
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
    );
  }
}
