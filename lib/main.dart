// Student Name: SANAUL HAQUE

import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(home: DigitalPetApp(), debugShowCheckedModeBanner: false));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Buster";
  int happinessLevel = 50;
  int hungerLevel = 50;
  final TextEditingController _controller = TextEditingController();
  Timer? _winTimer;
  int _secondsAboveEighty = 0;
  int energyLevel = 100;

  void _checkWinLoss() {
    setState(() {
      if (happinessLevel > 80) {
        _secondsAboveEighty += 1;
      } else {
        _secondsAboveEighty = 0;
      }
      if (_secondsAboveEighty >= 180) {
        _winTimer?.cancel();
        _showGameOverAlert("You win!");
      } else if (hungerLevel == 100 && happinessLevel <= 10) {
        _winTimer?.cancel();
        _showGameOverAlert("Game Over!");
      }
    });
  }

  void _showGameOverAlert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      energyLevel -= 5;
      if (energyLevel < 0) {
        energyLevel = 0;
      }
      if (happinessLevel > 100) {
        happinessLevel = 100;
      }
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      energyLevel += 5;
      if (energyLevel > 100) {
        energyLevel = 100;
      }
      if (hungerLevel < 0) {
        hungerLevel = 0;
      }
      _updateHappiness();
    });
  }

  void _rest() {
    setState(() {
      energyLevel += 20;
      if (energyLevel > 100) {
        energyLevel = 100;
        return;
      }
      hungerLevel += 5;
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
    if (happinessLevel > 100) {
      happinessLevel = 100;
    }
    if (happinessLevel < 0) {
      happinessLevel = 0;
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
      if (happinessLevel < 0) {
        happinessLevel = 0;
      }
    });
  }

  Color _moodColor(int happinessLevel) {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String _getMoodText() {
    if (happinessLevel > 70) {
      return "Happy 😊";
    } else if (happinessLevel >= 30) {
      return "Neutral 😑";
    } else {
      return "Unhappy 😡";
    }
  }

  void _setName() {
    setState(() {
      petName = _controller.text;
    });
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 30), (timer) {
      _updateHunger();
    });
    _winTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _checkWinLoss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '${180 - _secondsAboveEighty}s Left To Win The Game',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _getMoodText(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _moodColor(happinessLevel),
                BlendMode.modulate,
              ),
              child: Image.asset('assets/pet.png', height: 250),
            ),
            SizedBox(height: 8.0),
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextField(controller: _controller, maxLength: 50),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: (_setName),
                    child: Text("Name Your Pet 🐶"),
                  ),
                ],
              ),
            ),
            Text('Name: $petName', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 2.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 2.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 2.0),
            Text('Energy Level: $energyLevel%', style: TextStyle(fontSize: 16)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              child: LinearProgressIndicator(
                value: energyLevel / 100,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color.fromARGB(255, 47, 205, 33),
                ),
                minHeight: 10,
              ),
            ),
            SizedBox(
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _playWithPet,
                    child: Text('Play with Your Pet'),
                  ),
                  // SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: _feedPet,
                    child: Text('Feed Your Pet'),
                  ),
                  ElevatedButton(onPressed: _rest, child: Text('Rest')),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _winTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
