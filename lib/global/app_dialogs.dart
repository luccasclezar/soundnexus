import 'package:flutter/material.dart';

Future<bool> showAlert({
  required BuildContext context,
  required String positiveText,
  required String title,
  required String message,
  String? negativeText,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        actions: [
          if (negativeText != null)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(negativeText),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(positiveText),
          ),
        ],
        content: Text(message),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    },
  );

  return result ?? false;
}
