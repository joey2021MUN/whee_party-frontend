import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  final Function onStateReady;

  LoadingDialog({required this.onStateReady, super.key});

  LoadingDialogState? state;

  @override
  State createState() {
    state = LoadingDialogState();
    return state!;
  }
}

class LoadingDialogState extends State<LoadingDialog> {
  String _content = "";

  @override
  void initState() {
    super.initState();
    widget.onStateReady();
  }

  void updateContent(String content) {
    setState(() {
      _content = content;
    });
  }

  void close() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircularProgressIndicator(),
        Container(
          margin: const EdgeInsets.only(left: 24),
          child: Text(_content),
        ),
      ],
    );
  }
}
