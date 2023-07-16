import 'package:app_good_taste/app/model/flavor_model.dart';
import 'package:app_good_taste/app/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductController extends ChangeNotifier {
  final List<ProductModel> _products = [];

  List<ProductModel> get products {
    return [..._products];
  }

  Future<void> loadProducts() async {
    
  }

  Future<void> save(
      int? id, String name, double price, List<FlavorModel> flavors) async {
    if (id == null) {
      final Map<String, dynamic> newProduct = {
        "id": id,
        "name": name,
        "price": price,
        "flavors": flavors,
      };

      _products.add(newProduct as ProductModel);
      await ProductModel(
        name: name,
        id: id,
        price: price,
      ).save(flavors);
    }

    notifyListeners();
  }
}
