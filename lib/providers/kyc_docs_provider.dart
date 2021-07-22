import 'package:acc/models/kyc/kyc_documents.dart';
import 'package:flutter/foundation.dart';
import '../services/kyc_documents_service.dart';

class KYCDocuments with ChangeNotifier {
  List<OptionsData> _documents = [];

  List<OptionsData> get documents {
    return [..._documents];
  }

  Future<void> fetchAndSetKYCDocuments() async {
    clear();
    final KYCDocument extractedData =
        await KYCDocumentService.fetchKYCDocuments();
    if (extractedData == null) {
      return;
    }
    extractedData.data.options.forEach((option) {
      _documents.add(option);
    });
    notifyListeners();
  }

  void clear() {
    _documents = [];
    notifyListeners();
  }
}
