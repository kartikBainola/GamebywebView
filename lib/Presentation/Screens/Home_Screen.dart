import 'package:flutter/material.dart';

import '../../Data/game_repo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final games = GameRepository().getGames();

    return Scaffold(
      appBar: AppBar(title: const Text('Games')),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return ListTile(
            title: Text(game.name),
            onTap: () {
              // Handle game selection
            },
          );
        },
      ),
    );
  }
}
