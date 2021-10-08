import 'dart:convert';

import 'package:http/http.dart' as http;

import 'http_service.dart';
import '../models/products/product_type.dart';

class ProductTypeService {
  // Fetch Investment Product Types
  static Future<ProductType> fetchProductTypes() async {
    final response = await http.get(
        Uri.parse('${ApiServices.baseUrl}/sign-up/investment_product_types'));
    Map valueMap = jsonDecode(response.body);
    ProductType slots = ProductType.from(valueMap);

    return slots;
  }
}
