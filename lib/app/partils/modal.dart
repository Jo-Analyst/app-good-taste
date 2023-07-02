import 'package:flutter/material.dart';
import 'package:ice_cream/app/template/feedstock_form.dart';

class Modal {
  static showModal(BuildContext context, Map<String, dynamic> feedstockItem) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Feedstock(feedstockItem: feedstockItem);
      },
    );
  }
}
