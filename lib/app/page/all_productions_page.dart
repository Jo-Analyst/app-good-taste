import 'package:app_good_taste/app/page/production_details_list_page.dart';
import 'package:app_good_taste/app/template/slide_year.dart';
import 'package:flutter/material.dart';

class AllProductionsPage extends StatelessWidget {
  const AllProductionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> date = [
      {"month": "Janeiro", "number": 1},
      {"month": "Fevereiro", "number": 2},
      {"month": "Março", "number": 3},
      {"month": "Abril", "number": 4},
      {"month": "Maio", "number": 5},
      {"month": "Junho", "number": 6},
      {"month": "Julho", "number": 7},
      {"month": "Agosto", "number": 8},
      {"month": "Setembro", "number": 9},
      {"month": "Outubro", "number": 10},
      {"month": "Novembro", "number": 11},
      {"month": "Dezembro", "number": 12},
    ];
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
          style: TextStyle(fontSize: 25),
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
                const Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 30,
                    ),
                    SlideYear(),
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
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProductionDetailsListPage(),
                          ),
                        ),
                        child: Card(
                          elevation: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.black26,
                                  Theme.of(context).primaryColor,
                                ],
                              ),
                            ),
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
