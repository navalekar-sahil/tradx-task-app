import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_x_lite/view_model/stocks_view_model.dart';
import '../model/stock_model.dart';
import '../utils/currency_converter.dart';

class StockDetailScreen extends StatefulWidget {
  final StockModel stock;

  const StockDetailScreen({super.key, required this.stock});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {

  late StockModel stock;

  @override
  void initState() {
    super.initState();
    stock = widget.stock;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPositive = stock.change >= 0;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title:  Text("TradeX Lite",  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stock.symbol,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(stock.name),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatPrice(
                            price: stock.price,
                            currencyType: context.watch<StockViewModel>().selectedCurrency),

                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${stock.change.toStringAsFixed(2)}%",
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                height: 200,
                padding: const EdgeInsets.all(12),
                decoration: _cardDecoration(isDark),
                child: LineChart(_buildChart()),
              ),


              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: "Market Cap",
                      value: stock.marketCap,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: "Volume",
                      value: _formatVolume(stock.volume),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: "Open",
                      value: stock.open.toStringAsFixed(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: "Close",
                      value: stock.close.toStringAsFixed(2),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: "High",
                      value: stock.high.toStringAsFixed(2),
                      positive: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: "Low",
                      value: stock.low.toStringAsFixed(2),
                      positive: false,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(isDark),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Trading Volume"),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: (stock.volume / 10000000).clamp(0.0, 1.0),
                    ),
                    const SizedBox(height: 6),
                    Text(_formatVolume(stock.volume)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text("Recent Insights",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: _cardDecoration(isDark),
                child: Text(
                  "${stock.name} is showing ${isPositive ? "positive 📈" : "negative 📉"} momentum with a change of ${stock.change.toStringAsFixed(2)}%.",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _buildChart() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          spots: stock.history
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
              .toList(),
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: true),
        )
      ],
    );
  }

  BoxDecoration _cardDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? Colors.grey[900] : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black54 : Colors.grey.withOpacity(0.2),
          blurRadius: 8,
        )
      ],
    );
  }

  String _formatVolume(int vol) {
    if (vol >= 1000000) {
      return "${(vol / 1000000).toStringAsFixed(1)}M";
    } else if (vol >= 1000) {
      return "${(vol / 1000).toStringAsFixed(1)}K";
    }
    return vol.toString();
  }
}


class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final bool? positive;

  const StatCard({super.key, required this.title, required this.value, this.positive});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color? valueColor;
    if (positive != null) {
      valueColor = positive! ? Colors.green : Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }
}