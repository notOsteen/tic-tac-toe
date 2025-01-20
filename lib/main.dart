import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/tic_tac_toe.dart';
import 'ui/tic_tac_toe.dart';

void main() {
  Get.lazyPut(() => TicTacToeController());
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic-Tac-Toe',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const TicTacToeScreen(),
    );
  }
}
