import 'package:flutter/material.dart';

class DiaryCard extends StatelessWidget {

//A custom reusable Card class to save repetitive code in the project
//This class will create the card widget for the UI list

  final Widget child;
  final double? height;
  const DiaryCard({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color.fromRGBO(220, 220, 220, 0.4)
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 6,
              offset: const Offset(0, 4), 
            ),
          ],
        ),
        // Giving dynamic width to the card based on the screen size
        width: MediaQuery.of(context).size.width * 0.9,
        height: height ?? MediaQuery.of(context).size.height * 0.36,
        child: child,
      ),
    );
  }

}