import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {

 // Reusable class that returns a horizontal divider 

  final double paddingTop;
  final double paddingBottom; 
  final Color color;
  final double width;

  const HorizontalDivider({super.key, 
    this.paddingTop = 20,
    this.paddingBottom = 10,
    this.color = const Color.fromRGBO(220, 220, 220, 0.8),  
    this.width = 0.8,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Container(
        height: 1,
        color: const Color.fromRGBO(220, 220, 220, 0.8),
        width: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

}