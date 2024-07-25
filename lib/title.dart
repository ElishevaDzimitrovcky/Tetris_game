import 'package:flutter/material.dart';

class Tile extends StatelessWidget{
  final Color color;
  const Tile({required this.color});

  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.all(1),
      color: color,
    );
  }
}