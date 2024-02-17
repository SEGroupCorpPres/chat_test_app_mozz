import 'dart:ui';

import 'package:flutter/material.dart';

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

List<Color> leadingColor = [
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

String leading(String title) {
  int idxSp = title.indexOf(' ');
  List title0 = title.split('');
  String leading = title0.first + title0[idxSp + 1].toString().toUpperCase();
  return leading;
}