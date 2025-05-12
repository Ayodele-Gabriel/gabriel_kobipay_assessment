
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:gabriel_kobipay_assessment/model/transaction_model.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static String baseUrl = "https://run.mocky.io/v3/9d6e3883-0407-48b5-b8d9-b4ba0ec284d1";
  var client = http.Client();

  void toastMessage(String msg){
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG);
  }

  //GetHeader
  final _getHeader = {
    "accept": "application/json",
  };

  Future<TransactionModel> transactions() async {
    try {
      var url = Uri.parse(baseUrl);
      var response = await client.get(url, headers: _getHeader);
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return TransactionModel.fromJson(jsonData);
      } else {
        print('Status code: {response.statusCode}');
        toastMessage(jsonData['errors'].toString());
        throw Exception('Status: $jsonData');
      }
    } on TimeoutException catch (e) {
      toastMessage('Connection Timeout');
      throw Exception('Status: $e');
    } on SocketException catch (f) {
      toastMessage('Network is unreachable');
      throw Exception('Status: $f');
    } on http.ClientException {
      toastMessage('Unable to connect, please try again');
      throw Exception('Status: ${http.ClientException}');
    }
  }
}
