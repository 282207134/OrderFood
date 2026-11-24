import 'package:flutter/material.dart';

import 'core/order_state.dart';
import 'core/ui.dart';
import 'features/auth.dart';

class TastyFoodApp extends StatefulWidget {
  const TastyFoodApp({super.key});

  @override
  State<TastyFoodApp> createState() => _TastyFoodAppState();
}

class _TastyFoodAppState extends State<TastyFoodApp> {
  final order = OrderState();

  @override
  void dispose() {
    order.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrderScope(
      state: order,
      child: MaterialApp(
        title: 'Tasty Food',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Palette.orange),
          scaffoldBackgroundColor: Palette.paper,
          textTheme: ThemeData.light().textTheme.apply(
            bodyColor: Palette.ink,
            displayColor: Palette.ink,
          ),
          dividerColor: Palette.line,
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: Palette.muted),
            border: UnderlineInputBorder(),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Palette.paper,
            surfaceTintColor: Colors.transparent,
          ),
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}
