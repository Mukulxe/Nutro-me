import 'package:flutter/material.dart';

class CustomToast {
  void showToast(BuildContext context, String text, bool error) {
    Future.delayed(Duration.zero, () {
      // ignore: unnecessary_this
      this.delay(context, text, error);
    });
  }

  void delay(BuildContext context, String text, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 3000),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        backgroundColor: error ? Colors.red : Theme.of(context).primaryColor,
        content: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            error
                ? const Icon(
                    Icons.error,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
            const SizedBox(
              width: 15,
            ),
            error
                ? Text(
                    text,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.normal),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.normal),
                  ),
          ],
        ),
      ),
    );
  }
}
