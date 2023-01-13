import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:flutter/material.dart';

class AppBigText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final int maxlines;
  final TextOverflow overflow;
  final TextAlign? textAlign;
  const AppBigText({
    Key? key,
    this.color,
    required this.text,
    this.size = 0,
    this.maxlines = 1,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxlines,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: size == 0 ? AppDimensions.font28 : size,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
