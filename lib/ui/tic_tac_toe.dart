import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';
import 'package:tic_tac/controller/tic_tac_toe.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));
  final TicTacToeController ctrlr = Get.find();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrlr.showPlayerNameDialog(context);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicTacToeController>(
      builder: (controller) {
        if (controller.winner.value != null) {
          _confettiController.play();
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              final brightness = Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark;
              Get.changeThemeMode(
                brightness == Brightness.dark
                    ? ThemeMode.dark
                    : ThemeMode.light,
              );
            },
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final double gridSize =
                  (constraints.maxWidth < constraints.maxHeight
                          ? constraints.maxWidth
                          : constraints.maxHeight) *
                      0.6;
              final double cellSize = gridSize / 3;

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      colors: const [
                        Colors.red,
                        Colors.blue,
                        Colors.green,
                        Colors.yellow,
                      ],
                    ),
                    Text(
                      controller.winner.value == null
                          ? '${controller.currentPlayer.value == 'X' ? controller.playerXName : controller.playerOName}\'s Turn'
                          : controller.winner.value == 'Draw'
                              ? 'It\'s a Draw!'
                              : '${controller.winner.value == 'X' ? controller.playerXName : controller.playerOName} Wins!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: gridSize,
                      width: gridSize,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        padding: const EdgeInsets.all(16.0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => controller.handleTap(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: controller.board[index].isEmpty
                                    ? Colors.grey[300]
                                    : (controller.board[index] == 'X'
                                        ? Colors.blue[300]
                                        : Colors.red[300]),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Text(
                                    controller.board[index],
                                    key: ValueKey<String>(
                                        controller.board[index]),
                                    style: TextStyle(
                                      fontSize: cellSize * 0.4,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: controller.resetGame,
                          child: const Text('Restart Game'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
