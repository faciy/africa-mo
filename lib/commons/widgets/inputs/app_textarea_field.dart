// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class AppTextareaField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String name;
  String? label;
  final String hintText;
  final int? limitNumber;
  final int? maxline;
  final String? helperText;
  final int? helperMaxLines;
  final String? counterText;
  bool? is0bscureText = false;
  bool? autofocus = false;
  Function(String?)? onChange;
  List<String? Function(String?)>? validators = [];

  AppTextareaField({
    Key? key,
    required this.textEditingController,
    required this.name,
    required this.hintText,
    this.label,
    this.is0bscureText = false,
    this.autofocus = false,
    this.validators,
    this.limitNumber,
    this.maxline,
    this.helperText,
    this.helperMaxLines,
    this.counterText,
    this.onChange,
  }) : super(key: key);

  @override
  State<AppTextareaField> createState() => _AppTextareaFieldState();
}

class _AppTextareaFieldState extends State<AppTextareaField> {
  bool? visibilityPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          AppSmallText(
            text: widget.label!,
            size: AppDimensions.font16,
          ),
        SizedBox(
          height: AppDimensions.height5,
        ),
        FormBuilderTextField(
          autofocus: widget.autofocus!,
          cursorColor: Theme.of(context).brightness == Brightness.light
              ? AppColors.primary
              : AppColors.white,
          name: widget.name,
          maxLines: widget.maxline ?? 5,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.multiline,
          onChanged: widget.onChange,
          inputFormatters: [
            LengthLimitingTextInputFormatter(widget.limitNumber),
          ],
          decoration: InputDecoration(
            counterText: widget.counterText,
            helperText: widget.helperText,
            helperStyle: TextStyle(fontSize: AppDimensions.font10),
            hintText: widget.hintText,
            filled: true,
            fillColor: (Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : AppColors.dark),
            focusedBorder: OutlineInputBorder(
              gapPadding: 0.0,
              borderSide: BorderSide(
                color: AppColors.primary.withOpacity(0.7),
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              gapPadding: 0.0,
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.7), width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              gapPadding: 0.0,
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.7), width: 1.0),
            ),
            errorMaxLines: 1,
            errorStyle: const TextStyle(
              color: AppColors.white,
              height: 0,
              decoration: TextDecoration.none,
            ),
            errorBorder: OutlineInputBorder(
              gapPadding: 0,
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.7),
                width: 1.0,
              ),
            ),
            border: OutlineInputBorder(
              gapPadding: 0,
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.7), width: 1.0),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: AppDimensions.height15,
              horizontal: AppDimensions.height15,
            ),
          ),
          validator: FormBuilderValidators.compose(widget.validators ?? []),
          controller: widget.textEditingController,
        ),
      ],
    );
  }
}
