import "package:flutter/material.dart";

class ErrorOccured extends StatelessWidget {
  const ErrorOccured({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Image.asset("assets/e.png"),
            SizedBox(
              height: 50,
            ),
            Text(
              "Check Your Connection",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
