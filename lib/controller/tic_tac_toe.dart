import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicTacToeController extends GetxController {
  var board = List.generate(9, (_) => '').obs;
  var currentPlayer = 'X'.obs;
  var winner = RxnString();
  var playerXName = 'Player X';
  var playerOName = 'Player O';

  void handleTap(int index) {
    if (board[index].isEmpty && winner.value == null) {
      board[index] = currentPlayer.value;
      if (checkWinner()) {
        winner.value = currentPlayer.value;
      } else if (!board.contains('')) {
        winner.value = 'Draw';
      } else {
        currentPlayer.value = currentPlayer.value == 'X' ? 'O' : 'X';
      }
    }
    update();
  }

  bool checkWinner() {
    const List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];
    for (var pattern in winPatterns) {
      if (board[pattern[0]] == currentPlayer.value &&
          board[pattern[1]] == currentPlayer.value &&
          board[pattern[2]] == currentPlayer.value) {
        return true;
      }
    }
    return false;
  }

  void setPlayerNames(String xName, String oName) {
    playerXName = xName;
    playerOName = oName;
    update();
  }

  void showPlayerNameDialog(BuildContext context) {
    final controller = Get.find<TicTacToeController>();
    String playerXName = '';
    String playerOName = '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Player Names'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Player X Name'),
                keyboardType: TextInputType.name,
                onChanged: (value) => playerXName = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Player O Name'),
                keyboardType: TextInputType.name,
                onChanged: (value) => playerOName = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (playerXName.isNotEmpty && playerOName.isNotEmpty) {
                  controller.setPlayerNames(playerXName, playerOName);
                  Get.back();
                } else {
                  Get.snackbar(
                    'Error',
                    'Both names must be provided!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Text('Start Game'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    board.value = List.generate(9, (_) => '');
    currentPlayer.value = 'X';
    winner.value = null;
    update();
  }
}
