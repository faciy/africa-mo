// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:intl/intl.dart';

class AppDateField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String name;
  final String label;
  final String? helperText;
  final IconData? icon;
  final IconData? iconSuffix;
  final TextStyle? style;
  final bool? autoFocus;
  final bool? readOnly;
  final bool? enabled;
  final int? maxline;
  final int? helperMaxLines;
  final Color? fillColor;
  final String? counterText;
  final bool? lastDate;
  final AutovalidateMode? autovalidateMode;
  String? hintText;
  List<String? Function(DateTime?)>? validator = [];
  VoidCallback? onTap;
  VoidCallback? onTapSuffixIcon;
  Function(DateTime?)? onChange;
  FocusNode? focusNode;

  AppDateField({
    Key? key,
    required this.textEditingController,
    required this.name,
    required this.label,
    this.hintText,
    this.helperText,
    this.fillColor,
    this.style,
    this.autovalidateMode,
    this.icon,
    this.iconSuffix,
    this.validator,
    this.autoFocus = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxline,
    this.counterText,
    this.helperMaxLines,
    this.focusNode,
    this.lastDate = false,
    this.onTap,
    this.onTapSuffixIcon,
    this.onChange,
  }) : super(key: key);

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      inputType: widget.lastDate == false ? InputType.both : InputType.date,
      style: TextStyle(fontSize: AppDimensions.font10 + 1),
      lastDate: widget.lastDate == false ? DateTime(2100) : null,
      initialDate: DateTime.now(),
      firstDate: widget.lastDate == false ? DateTime.now() : null,
      controller: widget.textEditingController,
      name: widget.name,
      enabled: widget.enabled!,
      format: widget.lastDate == false
          ? DateFormat('dd-MM-yyyy hh:mm')
          : DateFormat('dd-MM-yyyy'),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.center,
        label: AppBigText(
          text: widget.label,
          size: AppDimensions.font20,
        ),
        contentPadding: EdgeInsets.zero,
        isDense: true,
        prefixIcon: const Icon(Icons.calendar_month),
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
        hintText: widget.hintText,
      ),
      onChanged: widget.onChange,
      validator: FormBuilderValidators.compose(widget.validator ?? []),
    );
  }
}
