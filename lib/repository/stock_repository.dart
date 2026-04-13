import 'dart:convert';
import 'package:flutter/services.dart';

import '../../model/stock_model.dart';

class MockDataRepository {

  Future<List<StockModel>> loadStocks() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/stocks.json');

      print(jsonString);

      final List data = json.decode(jsonString);

      return data.map((e) => StockModel.fromJson(e)).toList();
    } catch (e) {
      print("error: $e");
      return [];
    }
  }
}