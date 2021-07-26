import 'dart:async';
import 'dart:convert';

import 'package:acc/models/fund/add_fund_request.dart';
import 'package:acc/models/fund/add_fund_response.dart';
import 'package:http/http.dart' as http;
import 'package:acc/services/http_service.dart';

class FundService {
  // Upload Fund Details
  static Future<AddFundResponse> addFund(AddFundRequestModel request) async {
    final url = Uri.parse("${ApiServices.baseUrl}/fund");
    final headers = {
      "Content-type": "application/json",
      "authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGVfbm8iOiJQQ1h0eXBXL1hhbUVHSkRjdnhKMEx3PT0iLCJlbWFpbF9pZCI6IndNYjdidUtyaTc4MFFkQ0Rka0RTRm5PVDExNDBwbk9LQ2U2eFFSd3FZbk09IiwiZmlyc3RfbmFtZSI6IlRiLytrOU96TmxUUHdZRWt2TUdMQmc9PSIsIm1pZGRsZV9uYW1lIjoiIiwibGFzdF9uYW1lIjoiaUViaCt0aGJOcE1HZzdkdU40WnM5dz09IiwidXNlcl90eXBlIjoiaW52ZXN0b3IiLCJpZCI6NTgsImlhdCI6MTYyNjY4OTY3M30.EkrjAjCAXaUhlfraUtZCts9tV1MJpiwO7zMKfxQDDis",
    };
    final jsonBody = jsonEncode(request);

    print('URL: $url');
    print("Body:$jsonBody");

    final response = await http.post(url, headers: headers, body: jsonBody);
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    print('AddFund Resp: $valueMap');
    AddFundResponse fundTxnDetails = AddFundResponse.from(valueMap);
    return fundTxnDetails;
  }
}
