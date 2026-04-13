import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:trade_x_lite/utils/components/snackbar.dart';
import '../model/stock_model.dart';
import '../repository/stock_repository.dart';

class StockViewModel extends ChangeNotifier {
  final MockDataRepository _dataRepo = MockDataRepository();

  List<StockModel> _allStocks = []; // full data
  List<StockModel> _visibleStocks = []; // paginated list
  List<StockModel> _filteredStocks = [];

  Timer? _timer;

  int refreshInterval = 5;
  String _selectedCurrencyType = "inr";

  int _page = 1;
  final int _limit = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  String get selectedCurrency => _selectedCurrencyType;
  List<StockModel> get stocks => _visibleStocks;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  Future<void> loadStocks() async {
    _allStocks = await _dataRepo.loadStocks();

    _filteredStocks = _allStocks;

    _resetPagination();

    startRealtimeUpdates();
    notifyListeners();
  }

  void _resetPagination() {
    _page = 1;
    _visibleStocks = [];
    _hasMore = true;
    loadMore();
  }

  void loadMore() {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      final start = (_page - 1) * _limit;
      final end = start + _limit;

      if (start >= _filteredStocks.length) {
        _hasMore = false;
      } else {
        _visibleStocks.addAll(
          _filteredStocks.sublist(
            start,
            end > _filteredStocks.length
                ? _filteredStocks.length
                : end,
          ),
        );
        _page++;
      }

      _isLoadingMore = false;
      notifyListeners();
    });
  }

  void startRealtimeUpdates() {
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: refreshInterval), (_) {
      _updatePrices();
    });
  }

  void _updatePrices() {
    final random = Random();

    for (var stock in _allStocks) {
      double change = (random.nextDouble() - 0.5) * 4;
      stock.price += change;
      stock.change = change;

      stock.history.add(stock.price);
      if (stock.history.length > 20) {
        stock.history.removeAt(0);
      }
    }

    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
      _filteredStocks = _allStocks;
    } else {
      _filteredStocks = _allStocks.where((s) {
        return s.name.toLowerCase().contains(query.toLowerCase()) ||
            s.symbol.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    _resetPagination();
    notifyListeners();
  }

  void filter(String type) {
    switch (type) {
      case "gainers":
        _filteredStocks = _allStocks.where((s) => s.change > 0).toList();
        break;
      case "losers":
        _filteredStocks = _allStocks.where((s) => s.change < 0).toList();
        break;
      default:
        _filteredStocks = _allStocks;
    }

    _resetPagination();
    notifyListeners();
  }

  void updateInterval(int seconds, BuildContext context) {
    refreshInterval = seconds;
    Util.snackBar(
      message: "Interval set successfully on $seconds sec",
      context: context,
    );
    startRealtimeUpdates();
  }

  void updateCurrencyType(String currencyType) {
    _selectedCurrencyType = currencyType;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}