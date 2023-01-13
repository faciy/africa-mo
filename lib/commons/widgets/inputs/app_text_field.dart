// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  String? initialValue = '';
  String? label;
  final String name;
  final String hintText;
  final String? helperText;
  final IconData? icon;
  final IconData? iconSuffix;
  final TextInputType? type;
  final TextStyle? style;
  final bool? autoFocus;
  final bool? readOnly;
  final bool? enabled;
  final int? maxline;
  final int? helperMaxLines;
  final int? limitNumber;
  final Color? fillColor;
  final String? counterText;
  final AutovalidateMode? autovalidateMode;
  bool? is0bscureText = false;
  List<String? Function(String?)>? validators = [];
  VoidCallback? onTap;
  VoidCallback? onTapSuffixIcon;
  Function(String?)? onChange;
  Function(String?)? onSaved;
  FocusNode? focusNode;

  AppTextField({
    Key? key,
    required this.textEditingController,
    this.initialValue,
    this.label,
    required this.name,
    required this.hintText,
    this.helperText,
    this.fillColor,
    this.style,
    this.autovalidateMode,
    this.icon,
    this.iconSuffix,
    this.is0bscureText = false,
    this.validators,
    this.type,
    this.autoFocus = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxline,
    this.counterText,
    this.helperMaxLines,
    this.limitNumber,
    this.focusNode,
    this.onTap,
    this.onTapSuffixIcon,
    this.onChange,
    this.onSaved,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
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
          initialValue: widget.initialValue,
          cursorColor: AppColors.primary,
          autofocus: widget.autoFocus!,
          enabled: widget.enabled!,
          enableSuggestions: true,
          autovalidateMode:
              widget.autovalidateMode ?? AutovalidateMode.disabled,
          name: widget.name,
          onTap: widget.onTap,
          focusNode: widget.focusNode,
          onChanged: widget.onChange,
          onSaved: widget.onSaved,
          maxLines: widget.maxline ?? 1,
          textAlign: TextAlign.start,
          keyboardType: widget.type ?? TextInputType.text,
          readOnly: widget.readOnly!,
          style: widget.style,
          inputFormatters: widget.type != null
              ? [
                  LengthLimitingTextInputFormatter(widget.limitNumber),
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : null,
          obscureText: widget.is0bscureText!
              ? !visibilityPassword!
              : visibilityPassword!,
          decoration: InputDecoration(
            counterText: widget.counterText,
            isDense: true,
            contentPadding: const EdgeInsets.all(1),
            filled: true,
            fillColor: widget.enabled!
                ? widget.fillColor ??
                    (Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : AppColors.dark)
                : Colors.grey.withOpacity(0.3),
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
            helperMaxLines: widget.helperMaxLines,
            helperText: widget.helperText,
            helperStyle: TextStyle(fontSize: AppDimensions.font10),
            hintText: widget.hintText,
            prefixIcon: widget.is0bscureText!
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        visibilityPassword = !visibilityPassword!;
                      });
                    },
                    icon: Icon(
                      visibilityPassword!
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: AppDimensions.font18,
                      color: AppColors.grey,
                    ),
                  )
                : (widget.icon != null
                    ? Icon(
                        widget.icon,
                        size: AppDimensions.font18,
                        color: AppColors.grey,
                      )
                    : const SizedBox()),
            suffixIcon: IconButton(
              onPressed: widget.onTapSuffixIcon,
              icon: Icon(
                widget.iconSuffix,
                size: AppDimensions.font18,
              ),
            ),
          ),
          validator: FormBuilderValidators.compose(widget.validators ?? []),
          controller: widget.textEditingController,
        ),
      ],
    );
  }
}
