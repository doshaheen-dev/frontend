import 'dart:convert';

import 'package:acc/models/products/product_type.dart';
import 'package:flutter/foundation.dart';
import '../services/product_type_service.dart';

class ProductTypes with ChangeNotifier {
  List<InvestmentLimitItem> _types = [];
  List<InvestmentLimitItem> _selectedTypes = [];

  List<InvestmentLimitItem> get types {
    return [..._types];
  }

  List<InvestmentLimitItem> get selectedTypes {
    return [..._selectedTypes];
  }

  Future<void> fetchAndSetProductTypes() async {
    final List<InvestmentLimitItem> loadedProductTypes = [];
    final ProductType extractedData =
        await ProductTypeService.fetchProductTypes();
    if (extractedData == null) {
      return;
    }
    extractedData.data.options.forEach((option) {
      loadedProductTypes.add(InvestmentLimitItem(
        option.id,
        option.name,
        option.desc,
        false,
        false,
      ));
    });

    _types = loadedProductTypes.toList();
    notifyListeners();
  }

  void checkOption(InvestmentLimitItem type) {
    _selectedTypes.add(type);
    notifyListeners();
  }

  void uncheckOption(InvestmentLimitItem type) {
    _selectedTypes.remove(type);
    notifyListeners();
  }

  void clear() {
    _selectedTypes = [];
    notifyListeners();
  }
}

class InvestmentLimitItem {
  final int id;
  final String name;
  final String description;
  bool isExpanded = false;
  bool isCheck = false;

  InvestmentLimitItem(
    this.id,
    this.name,
    this.description,
    this.isExpanded,
    this.isCheck,
  );
}
