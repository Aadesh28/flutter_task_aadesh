import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
//A custom reusable button class to save repetitive code in the project
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double width;

  const CustomElevatedButton({super.key, 
    required this.text,
    required this.onPressed,
    this.height = 50, 
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
                         decoration: BoxDecoration(
                              boxShadow: [

                              //This property will add shadow to the button
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 6,
                                  offset: const Offset(0, 4), 
                                ),
                              ],
                            ),
                          child: SizedBox(
                            //Managing dimensions of the button
                                  width: width,
                                  height: 60,
                                child: ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(165, 212, 66, 1) 
                                 ),
                                  onPressed: onPressed, child: Text(text,style: const TextStyle(fontSize: 16),),),
                              ),
                        );
  }
}