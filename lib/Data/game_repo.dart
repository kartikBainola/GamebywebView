import '../Models/game.dart';
import '../Models/platform.dart';

class GameRepository {
  final List<Game> _games = [
    Game(
        id: '1',
        name: 'Call of Duty®: Black Ops 6',
        url:
            'https://store.steampowered.com/app/2933620/Call_of_Duty_Black_Ops_6/'),
    Game(
        id: '2',
        name: "Don't Starve Together ",
        url: 'https://example.com/game2'),
    Game(id: '4', name: 'Cities: Skylines', url: 'https://example.com/game3'),
    Game(id: '5', name: 'Dead by Daylight', url: 'https://example.com/game3'),
    Game(id: '6', name: 'Windblown', url: 'https://example.com/game3'),
    Game(
        id: '7', name: 'Rivals of Aether II', url: 'https://example.com/game3'),
    Game(id: '8', name: 'DAVE THE DIVER', url: 'https://example.com/game3'),
    Game(id: '9', name: 'Fallout 4', url: 'https://example.com/game3'),
    Game(id: '10', name: 'Core Keepers', url: 'https://example.com/game3'),
    Game(id: '11', name: 'Dying Light', url: 'https://example.com/game3'),
    Game(id: '12', name: 'Forza Horizon 4', url: 'https://example.com/game3'),
    Game(
        id: '13',
        name: 'Sid Meier’s Civilization® VI',
        url: 'https://example.com/game3'),
    Game(id: '14', name: "No Man's Sky", url: 'https://example.com/game3'),
    Game(id: '15', name: 'Fallout 76', url: 'https://example.com/game3'),
  ];

  final List<Platform> _platforms = [
    Platform(id: '1', name: 'Steam', url: 'https://store.steampowered.com'),
    Platform(id: '2', name: 'Epic Games', url: 'https://www.epicgames.com'),
    Platform(id: '3', name: 'GOG', url: 'https://www.gog.com'),
    Platform(id: '4', name: 'Crazy Game', url: 'https://www.crazygames.com'),
  ];

  List<Game> getGames() => _games;
  List<Platform> getPlatforms() => _platforms;
}
