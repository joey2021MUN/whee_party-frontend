import 'package:flutter/material.dart';

import '../widget/loading_dialog.dart';

class UIUtil {
  static LoadingDialog? dialog;

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
