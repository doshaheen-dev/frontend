import 'dart:convert';

import 'package:http/http.dart' as http;

import 'http_service.dart';
import '../models/fundslot/fundslot.dart';

class FundSlotService {
  // Fetch Fund Slots
  static Future<FundSlot> fetchFundSlots() async {
    final response = await http
        .get(Uri.parse('${ApiServices.baseUrl}/sign-up/amount_range'));
    Map valueMap = jsonDecode(response.body);
    FundSlot slots = FundSlot.from(valueMap);
    return slots;
  }
}
