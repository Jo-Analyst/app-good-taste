// ignore_for_file: file_names

import 'package:flutter/material.dart';

class IceCreamView extends StatelessWidget {
  const IceCreamView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Ice Cream"),
        backgroundColor: Colors.pink.shade200,
        // centerTitle: true,
      ),
      body: const Center(
        child: Text("Ice Cream"),
      ),
    );
  }
}
