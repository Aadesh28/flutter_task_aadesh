import 'package:flutter/material.dart';

class CommonFunction{

  //This class will return a dialog box that can be reused in the application with options to access the device setting.
  confirmationDialog(
      BuildContext context, double height, String title, Function() onYes,
      { 
        String? content,
        Function? onNo}) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
                parent: a1,
                curve: Curves.easeOut,
                reverseCurve: Curves.easeIn)),
            child: StatefulBuilder(
              builder: (context, setState) => GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Material(
                  color: Colors.transparent,
                  child: Dialog(
                    insetPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.white,
                    child: Container(
                      height: height,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromRGBO(220, 220, 220, 0.4)
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                Text(title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(97, 97, 97, 1))),
                                if (content != null)
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 15),
                                      Text(content,
                                          textAlign: TextAlign.center),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buttons(
                                        context,
                                        'No',
                                            () {
                                          if (onNo != null) {
                                            onNo();
                                          }
                                          Navigator.of(context).pop();
                                        }),
              // The onYes callback will handle the onTap for the Setting option

                                    buttons(
                                        context,
                                        'Setting',
                                        onYes,
                                        isRightButton: true)
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget buttons(
      BuildContext context, String text,Function() onClick,
      {bool isRightButton = false}) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 47,
        width: 114,
        alignment: Alignment.center,
        decoration: isRightButton
            ? BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8))
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 15,
              color: Color.fromRGBO(97, 97, 97, 1)).copyWith(letterSpacing: 0.408),
        ),
      ),
    );
  }
}