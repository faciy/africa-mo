// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class AppSmallText extends StatelessWidget {
  final Color? color;
  final String text;
  final TextAlign? textAlign;
  final double size;
  final int maxline;
  final double height;
  final TextOverflow overflow;

  AppSmallText({
    Key? key,
    this.color,
    required this.text,
    this.textAlign,
    this.size = 12,
    this.maxline = 1,
    this.height = 1.3,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxline,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: size,
        height: height,
      ),
    );
  }
}
