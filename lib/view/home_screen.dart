import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_x_lite/utils/components/setting_bottom_sheet.dart';
import 'package:trade_x_lite/utils/components/stock_card.dart';
import '../view_model/stocks_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "all";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final stockVm = context.read<StockViewModel>();

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        stockVm.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title:  Text("TradeX Lite",  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),)),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Market Watch",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              decoration: InputDecoration(
                hintText: "Search stocks...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                context.read<StockViewModel>().search(value);
              },
            ),

            const SizedBox(height: 12),

            Consumer<StockViewModel>(
              builder: (context, stockVm, _) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _chip("All", "all", stockVm, isDark),
                      _chip("Gainers", "gainers", stockVm, isDark),
                      _chip("Losers", "losers", stockVm, isDark),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Consumer<StockViewModel>(
                builder: (context, stockVm, _) {

                  if (stockVm.stocks.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: stockVm.stocks.length + (stockVm.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < stockVm.stocks.length) {
                        final stock = stockVm.stocks[index];
                        return StockItemCard(
                            stock: stock,
                            isDark: isDark
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSettingsBottomSheet(context);
        },
        child: const Icon(Icons.settings),
      ),
    );
  }

  Widget _chip(String text, String type, StockViewModel stockVm, bool isDark) {
    final isSelected = selectedFilter == type;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(text),
        selected: isSelected,
        onSelected: (_) {
          stockVm.filter(type);
          stockVm.filter(type);
          setState(() => selectedFilter = type);
        },
        selectedColor:
        isDark ? Colors.deepPurpleAccent : Colors.deepPurple,
      ),
    );
  }
}