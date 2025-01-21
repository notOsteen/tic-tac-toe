import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerNamePopup extends StatelessWidget {
  final Function(String playerX, String playerO, bool isBot) onSubmit;

  const PlayerNamePopup({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    String playerXName = '';
    String playerOName = '';
    bool isBotPlaying = false;

    return AlertDialog(
      title: const Text('Choose Game Mode'),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: isBotPlaying,
                    onChanged: (value) {
                      setState(() {
                        isBotPlaying = value!;
                      });
                    },
                  ),
                  const Text('Player vs Player'),
                ],
              ),
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: isBotPlaying,
                    onChanged: (value) {
                      setState(() {
                        isBotPlaying = value!;
                      });
                    },
                  ),
                  const Text('Player vs Bot'),
                ],
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Player X Name'),
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  playerXName = value;
                },
              ),
              if (!isBotPlaying)
                TextField(
                  decoration: const InputDecoration(labelText: 'Player O Name'),
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    playerOName = value;
                  },
                ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (playerXName.isNotEmpty &&
                (isBotPlaying || playerOName.isNotEmpty)) {
              onSubmit(
                playerXName,
                isBotPlaying ? 'Bot' : playerOName,
                isBotPlaying,
              );
              Get.back();
            } else {
              Get.snackbar(
                'Error',
                'All fields must be filled!',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: const Text('Start Game'),
        ),
      ],
    );
  }
}
