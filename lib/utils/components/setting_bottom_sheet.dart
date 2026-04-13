import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_x_lite/view_model/theme_data_provider.dart';
import 'package:trade_x_lite/view_model/stocks_view_model.dart';

Future<void> showSettingsBottomSheet(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final intervals = [5, 10, 30, 60];

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          final themeProvider = context.watch<ThemeProvider>();
          final stockVM = context.watch<StockViewModel>();

          int selectedInterval = stockVM.refreshInterval;

          String currency = stockVM.selectedCurrency == "inr"
              ? "INR (Indian Rupee)"
              : stockVM.selectedCurrency == "usd"
              ? "USD (US Dollar)"
              : "EUR (Euro)";

          bool isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
              (themeProvider.themeMode == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness ==
                      Brightness.dark);

          final currencyMap = {
            "INR (Indian Rupee)": "inr",
            "USD (US Dollar)": "usd",
            "EUR (Euro)": "eur",
          };

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Settings",
                      style:
                      Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Icon(Icons.dark_mode),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dark Mode"),
                          Text(
                            "Optimize for low light",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isDarkMode,
                      onChanged: (val) {
                        themeProvider.setTheme(
                          val ? ThemeMode.dark : ThemeMode.light,
                        );
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),

                const SizedBox(height: 20),

                const Text("Refresh Interval"),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: intervals.map((value) {
                    return _intervalTimeButton(
                      value,
                      selectedInterval,
                          (val) {
                        setState(() => selectedInterval = val);
                        stockVM.updateInterval(val, context);
                      },
                      isDark,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                const Text("Base Currency"),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: currency,
                      isExpanded: true,
                      items: currencyMap.keys.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value,  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                          ),),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          stockVM.updateCurrencyType(currencyMap[val]!);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _intervalTimeButton(
    int value,
    int selected,
    Function(int) onTap,
    bool isDark,
    ) {
  final isSelected = value == selected;

  return GestureDetector(
    onTap: () => onTap(value),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? Colors.deepPurpleAccent : Colors.deepPurple)
            : (isDark ? Colors.black : Colors.grey[200]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "${value}s",
        style: TextStyle(
          color: isSelected ? Colors.white : null,
        ),
      ),
    ),
  );
}