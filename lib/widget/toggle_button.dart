import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final Widget child;
  final bool isOn;
  final VoidCallback? onPress;
  final bool isEnabled;
  final Color normalColor;
  final Color disabledColor;
  final Color selectedColor;

  const ToggleButton({
    super.key,
    this.onPress,
    required this.isOn,
    required this.isEnabled,
    required this.normalColor,
    required this.disabledColor,
    required this.selectedColor,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => ToggleButtonState();
}

class ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.isEnabled
          ? (widget.isOn
            ? widget.selectedColor
            : widget.normalColor)
          : widget.disabledColor,
      child: InkWell(
        onTap: widget.isEnabled ? widget.onPress : null,
        child: widget.child,
      ),
    );
  }
}
