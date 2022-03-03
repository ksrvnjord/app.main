import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';

class ErrorCardWidget extends StatelessWidget {
  const ErrorCardWidget({
    Key? key,
    required this.errorMessage,
    this.causingError,
     }) : super(key: key);

  final String errorMessage;
  final Object? causingError;

  @override
  Widget build(BuildContext context) {
    final Color errorColor = Colors.red.shade800;
    return GestureDetector(
      // onTap: () {
      //   const AlertDialog ad = AlertDialog(
      //     content: Text("Dingen vragen hiero")
      //   );

      //   showDialog(context: context, builder: (BuildContext context) {
      //     return ad;
      //   });
      // },s
      child: Container(
        height: 100.0,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: errorColor),
          borderRadius: BorderRadius.circular(10)
        ),

        // semanticContainer: false,
        // elevation: 0,
        // shape: RoundedRectangleBorder(
        //       side: BorderSide(color: errorColor, width: 2),
        //       borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              flex: 0,
              child: Image.asset(Images.deadSwan),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Er is iets misgegaan",
                      style: TextStyle(color: errorColor, fontSize: 18),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "Melding: " + errorMessage,
                          style: const TextStyle(fontSize: 14),
                        ),
                        alignment: Alignment.center,
                      ) 
                    ),
                    // const Expanded(
                    //   flex: 1,
                    //   child: Text(
                    //     "Tik hier om een foutrapport te verzenden",
                    //     style: TextStyle(fontSize: 10),
                    //   )
                    // )
                  ]
                )
              ) 
            )
            
          ]
        )
      )
    );
  }
}