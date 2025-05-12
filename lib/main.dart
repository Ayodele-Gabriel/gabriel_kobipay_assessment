import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gabriel_kobipay_assessment/home_screen/home_screen.dart';
import 'package:gabriel_kobipay_assessment/transaction_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KobiPay',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/transaction_detail': (context) => const TransactionDetail(),
      },
    );
  }
}
