import 'package:flutter/material.dart';

import '../widget/loading_dialog.dart';

class UIUtil {
  static LoadingDialog? dialog;

static alertDialog(BuildContext context, String content) {
  var alert = AlertDialog(
    content: Text(content),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('OK'),
      ),
    ],
  );
  showDialog(context: context, builder: (_) => alert);
}

  static closeLoadingDialog(BuildContext context) {
    dialog?.state?.close();
    dialog = null;
  }

  static updateLoadingDialog(BuildContext context, String content) {
    dialog?.state?.updateContent(content);
  }

  static showLoadingDialog(BuildContext context, String content) {
    closeLoadingDialog(context);

    dialog = LoadingDialog(onStateReady: () {
      updateLoadingDialog(context, content);
    });
    var alert = AlertDialog(
      content: dialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
