import 'package:app_good_taste/app/template/feedstock_form.dart';
import 'package:flutter/material.dart';
import 'package:app_good_taste/app/utils/modal.dart';
import 'package:app_good_taste/app/template/feedstock_list.dart';

class FeedstockPage extends StatelessWidget {
  const FeedstockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> feedstocks = [];

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
          style: TextStyle(fontSize: 30),
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
