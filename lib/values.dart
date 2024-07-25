import 'dart:ui';

import 'package:flutter/material.dart';

enum Direction {left, right, down}
enum TetrisShape {L, J, I, O, S, Z, T}

const Map<TetrisShape, Color> tetrisShapeColors = {
  TetrisShape.L: Color(0xFFFFA500),
  TetrisShape.J: Color(0xFF0000FF),
  TetrisShape.I: Color(0xFF00FFFF),
  TetrisShape.O: Color(0xFFFFFF00),
  TetrisShape.S: Color(0xFF00FF00),
  TetrisShape.Z: Color(0xFFFF0000),
  TetrisShape.T: Color(0xFF800080),
};
