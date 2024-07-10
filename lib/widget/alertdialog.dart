// alertdialog.dart
import 'package:flutter/material.dart';
import 'package:test_ta_1/widget/button_custom.dart';

void showAlertDialog({
  required BuildContext context,
  required Function onConfirm,
  required String imageAsset,
  required String message,
}) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imageAsset,
            width: 180,
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        ButtonCustom(
          label: 'Yes',
          hasShadow: false,
          onTap: () {
            onConfirm();
            Navigator.pop(context);
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Text(
              'No',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
