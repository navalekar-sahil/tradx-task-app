import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_x_lite/utils/currency_converter.dart';
import 'package:trade_x_lite/utils/routes_name.dart';

import '../../model/stock_model.dart';
import '../../view_model/stocks_view_model.dart';

class StockItemCard extends StatelessWidget {
  final StockModel stock;
  final bool isDark;

  const StockItemCard({
    super.key,
    required this.stock,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<StockViewModel>(
      builder: (context, vm, _) {
        final isPositive = stock.change >= 0;

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              RoutesName.stockDetailScreen,
              arguments: {"stock": stock},
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black54
                      : Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isDark
                          ? Colors.deepPurple
                          : Colors.deepPurple.shade100,
                      child: Text(
                        stock.symbol[0],
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : Colors.deepPurple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stock.symbol,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          formatPrice(
                            price: stock.price,
                            currencyType: vm.selectedCurrency,
                          ),
                          style: TextStyle(
                            color: isDark
                                ? Colors.grey
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Text(
                  "${stock.change.toStringAsFixed(2)}%",
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}