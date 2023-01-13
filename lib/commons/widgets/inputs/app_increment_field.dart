// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class AppIncrementField extends StatefulWidget {
  VoidCallback onIncrement;
  VoidCallback onDecrement;
  TextEditingController controller = TextEditingController();
  bool? isActive = false;
  AppIncrementField({
    Key? key,
    required this.onIncrement,
    required this.onDecrement,
    required this.controller,
    this.isActive,
  }) : super(key: key);

  @override
  State<AppIncrementField> createState() => _AppIncrementFieldState();
}

class _AppIncrementFieldState extends State<AppIncrementField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: widget.onIncrement,
          child: Container(
            padding: EdgeInsets.all(AppDimensions.height8),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(AppDimensions.radius30),
            ),
            child: Icon(
              Icons.add,
              size: AppDimensions.font13,
              color: AppColors.white,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: AppDimensions.width5,
          ),
          width: AppDimensions.width50,
          child: FormBuilderTextField(
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppDimensions.font18,
              fontWeight: FontWeight.bold,
            ),
            keyboardType: TextInputType.number,
            controller: widget.controller,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
            ),
            name: 'nbre_jour',
          ),
        ),
        InkWell(
          onTap: widget.isActive! ? widget.onDecrement : null,
          child: Container(
            padding: EdgeInsets.all(AppDimensions.height8),
            decoration: BoxDecoration(
              color: widget.isActive!
                  ? AppColors.black
                  : AppColors.grey.withOpacity(0.6),
              borderRadius: BorderRadius.circular(AppDimensions.radius30),
            ),
            child: Icon(
              Icons.remove,
              size: AppDimensions.font13,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
