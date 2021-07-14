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
    String symbol = extractedData.data.currencySymbol;
    extractedData.data.options.forEach((option) {
      if (option.toAmount.isEmpty) {
        loadedSlots
            .add(InvestmentLimitItem('Above ${option.fromAmount}$symbol'));
      } else {
        loadedSlots.add(InvestmentLimitItem(
            '${option.fromAmount}$symbol - ${option.toAmount}$symbol'));
      }
    });

    _slotLineItems = loadedSlots.toList();
    notifyListeners();
  }
}

class InvestmentLimitItem {
  final String header;
  InvestmentLimitItem(this.header);
}
