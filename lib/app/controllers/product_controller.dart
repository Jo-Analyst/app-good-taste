import 'package:app_good_taste/app/models/flavor_model.dart';
import 'package:app_good_taste/app/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductController extends ChangeNotifier {
  List<Map<String, dynamic>> _items = <Map<String, dynamic>>[];

  List<Map<String, dynamic>> get items {
    return [..._items];
  }

  Future<void> load() async {
    _items = await ProductModel.findAll();
    notifyListeners();
  }

  Future<void> loadingProductsAndFlavorsBYProductId(int productId) async {
    _items = await ProductModel.findAllPartsByProductId(productId);
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await ProductModel.delete(id);
    notifyListeners();
  }

  Future<void> save(
      int id, String name, double price, List<FlavorModel> flavors) async {
    // final Map<String, dynamic> newProduct = {
    //   "id": id,
    //   "name": name,
    //   "price": price,
    //   "flavors": flavors,
    // };

    // _items.add(newProduct);

    await ProductModel.save(flavors, {
      "name": name,
      "id": id,
      "price": price,
    });
    notifyListeners();
  }
}
