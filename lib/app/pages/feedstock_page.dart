import 'package:app_good_taste/app/controllers/feedstock_controller.dart';
import 'package:app_good_taste/app/template/feedstock_form.dart';
import 'package:flutter/material.dart';
import 'package:app_good_taste/app/utils/modal.dart';
import 'package:app_good_taste/app/template/feedstock_list.dart';
import 'package:provider/provider.dart';

class FeedstockPage extends StatefulWidget {
  const FeedstockPage({super.key});

  @override
  State<FeedstockPage> createState() => _FeedstockPageState();
}

class _FeedstockPageState extends State<FeedstockPage> {
  List<Map<String, dynamic>> feedstocks = [];
  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final feedstockProvider =
        Provider.of<FeedstockController>(context, listen: false);
    await feedstockProvider.loadFeedstock();
    setState(() {
      feedstocks = feedstockProvider.items;
    });
    print(feedstocks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => showModal(
                context,
                const Feedstock(feedstockItem: {}),
              ),
              icon: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ),
        ],
        title: const Text(
          "Gerenciar M. Prima",
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 100,
      ),
      body: feedstocks.isNotEmpty
          ? ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    itemCount: feedstocks.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                        child: FeedstockList(feedstocks[index]),
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                "Não há matéria prima cadastrada.",
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.displayLarge!.fontSize),
              ),
            ),
    );
  }
}
