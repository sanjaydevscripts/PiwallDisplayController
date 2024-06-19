import 'package:flutter/material.dart';
import 'package:pdc/screens/widgets/custom_text.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({
    super.key,
    required this.height,
    required this.width,
    this.radius = 10,
    this.iconWidget = const SizedBox(),
    required this.onPressed,
    required this.backgroundColor,
    required this.label,
    required this.labelColor,
    required this.labelSize,
  });
  final double height;
  final double width;
  final double radius;
  final Widget iconWidget;
  final void Function() onPressed;
  final Color backgroundColor;
  final String label;
  final Color labelColor;
  final double labelSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            Padding(
              padding: const EdgeInsets.all(0),
              child: CustomText(
                text: label,
                fontSize: labelSize,
                fontColor: labelColor,
                fontweight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
