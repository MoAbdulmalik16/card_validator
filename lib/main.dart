import 'package:card_validation/provider/index.dart';
import 'package:card_validation/ui/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CreditCardProvider()),
        ChangeNotifierProvider(create: (_) => BannedCountriesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Credit Card Validator',
      initialRoute: '/',
      routes: {
        '/': (context) => CreditCardFormPage(),
        '/bannedCountries': (context) => BannedCountriesPage(),
      },
    );
  }
}
