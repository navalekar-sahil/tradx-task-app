import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trade_x_lite/utils/routes.dart';
import 'package:trade_x_lite/utils/routes_name.dart';
import 'package:trade_x_lite/view_model/stocks_view_model.dart';
import 'package:trade_x_lite/view_model/theme_data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('historyBox');
  /// 🔥 Load saved theme BEFORE app starts
  final savedTheme = await ThemeProvider.loadThemeFromPrefs();

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => ThemeProvider(savedTheme),
        ),

        ChangeNotifierProvider(
          create: (_) => StockViewModel()..loadStocks(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'TradeX Lite',
      debugShowCheckedModeBanner: false,

      /// 🌞 Light Theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        brightness: Brightness.light,
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
      ),

      themeMode: themeProvider.themeMode,

      initialRoute: RoutesName.splashScreen,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}