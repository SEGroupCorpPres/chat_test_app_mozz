import 'package:flutter/material.dart';

class Constants {
  Color leadingColor(int index) => _leadingColor[index];
  List<Map<String, String>> chatItems = [
    {
      'title': 'Виктор Власов',
      'subtitle': 'Вы: Уже сделал?',
      'trailing': 'Вчера',
    },
    {
      'title': 'Саша Алексеев',
      'subtitle': 'Я готов',
      'trailing': '12.01.22',
    },
    {
      'title': 'Пётр Жаринов',
      'subtitle': 'Вы: Я вышел',
      'trailing': '2 минуты назад',
    },
    {
      'title': 'Алина Жукова',
      'subtitle': 'Вы: Я вышел',
      'trailing': '09:23',
    }
  ];

  final List<Color> _leadingColor = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.yellowAccent,
    Colors.pinkAccent,
    Colors.indigoAccent,
    Colors.cyanAccent,
    Colors.limeAccent,
    Colors.purpleAccent,
    Colors.amberAccent,
    Colors.tealAccent,
    Colors.lightGreenAccent,
    Colors.lightBlueAccent,
    Colors.deepOrangeAccent,
    Colors.deepPurpleAccent,
  ];
}
