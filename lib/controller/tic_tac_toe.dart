import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac/widgets/popup.dart';

class TicTacToeController extends GetxController {
  var board = List.generate(9, (_) => '').obs;
  var currentPlayer = 'X'.obs;
  var winner = RxnString();
  var playerXName = 'Player X';
  var playerOName = 'Bot';
  var isBotPlaying = true;

  static const List<List<int>> winPatterns = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ];

  bool isBotThinking = false;

  void handleTap(int index) async {
    if (!isBotPlaying || !isBotThinking) {
      if (board[index].isEmpty && winner.value == null) {
        board[index] = currentPlayer.value;
        if (checkWinner(currentPlayer.value)) {
          winner.value = currentPlayer.value;
        } else if (!board.contains('')) {
          winner.value = 'Draw';
        } else {
          currentPlayer.value = currentPlayer.value == 'X' ? 'O' : 'X';
          if (isBotPlaying && currentPlayer.value == 'O') {
            isBotThinking = true;
            await botMove();
            isBotThinking = false;
          }
        }
      }
      update();
    }
  }

  bool checkWinner(String player) {
    return winPatterns
        .any((pattern) => pattern.every((index) => board[index] == player));
  }

  Future<void> botMove() async {
    Get.snackbar(
      '',
      'Bot is thinking...',
      snackPosition: SnackPosition.BOTTOM,
      titleText: const SizedBox.shrink(),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    update();

    int? move;
    await Future.delayed(const Duration(seconds: 2));

    move = findBestMove(currentPlayer.value);
    if (move != null) {
      board[move] = currentPlayer.value;
      if (checkWinner(currentPlayer.value)) {
        winner.value = currentPlayer.value;
      } else {
        winner.value = null;
        currentPlayer.value = 'X';
      }
      update();
      return;
    }

    String opponent = currentPlayer.value == 'X' ? 'O' : 'X';
    move = findBestMove(opponent);
    if (move != null) {
      board[move] = currentPlayer.value;
      winner.value = null;
      currentPlayer.value = 'X';
      update();
      return;
    }

    if (board[4].isEmpty) {
      board[4] = currentPlayer.value;
      winner.value = null;
      currentPlayer.value = 'X';
      update();
      return;
    }

    List<int> corners = [0, 2, 6, 8];
    move =
        corners.firstWhere((index) => board[index].isEmpty, orElse: () => -1);
    if (move != -1) {
      board[move] = currentPlayer.value;
      winner.value = null;
      currentPlayer.value = 'X';
      update();
      return;
    }

    move = board.indexWhere((cell) => cell.isEmpty);
    if (move != -1) {
      board[move] = currentPlayer.value;
      winner.value = null;
      currentPlayer.value = 'X';
      update();
    }
  }

  int? findBestMove(String player) {
    for (var pattern in winPatterns) {
      int count = 0;
      int emptyIndex = -1;
      for (var index in pattern) {
        if (board[index] == player) {
          count++;
        } else if (board[index].isEmpty) {
          emptyIndex = index;
        }
      }
      if (count == 2 && emptyIndex != -1) {
        return emptyIndex;
      }
    }
    return null;
  }

  void resetGame() {
    board.value = List.generate(9, (_) => '');
    currentPlayer.value = 'X';
    winner.value = null;
    update();
  }

  void showPlayerNameDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PlayerNamePopup(
          onSubmit: (playerX, playerO, isBot) {
            playerXName = playerX;
            playerOName = playerO;
            isBotPlaying = isBot;
            update();
          },
        );
      },
    );
  }
}
