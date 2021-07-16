import 'dart:convert';

import 'package:acc/models/fundslot/fundslot.dart';
import 'package:flutter/foundation.dart';
import '../services/fund_slot_service.dart';

class FundSlots with ChangeNotifier {
  List<InvestmentLimitItem> _slotLineItems = [];

  List<InvestmentLimitItem> get slotLineItems {
    return [..._slotLineItems];
  }

  Future<void> fetchAndSetSlots() async {
    final List<InvestmentLimitItem> loadedSlots = [];
    final FundSlot extractedData = await FundSlotService.fetchFundSlots();
    if (extractedData == null) {
      return;
    }
    extractedData.data.options.forEach((option) {
      loadedSlots.add(InvestmentLimitItem(option.range));
    });

    _slotLineItems = loadedSlots.toList();
    notifyListeners();
  }
}

class InvestmentLimitItem {
  final String header;
  InvestmentLimitItem(this.header);
}
