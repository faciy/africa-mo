// ignore_for_file: must_be_immutable

import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AppPinCodeField extends StatefulWidget {
  final TextEditingController textEditingController;
  bool? is0bscureText = false;
  FormFieldSetter<String> onSave;
  List<String? Function(String?)>? validators = [];

  AppPinCodeField({
    Key? key,
    required this.textEditingController,
    required this.onSave,
    this.validators,
  }) : super(key: key);

  @override
  State<AppPinCodeField> createState() => _AppPinCodeFieldState();
}

class _AppPinCodeFieldState extends State<AppPinCodeField> {
  bool? visibilityPassword = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimensions.width50,
      height: AppDimensions.height50,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.height5),
        child: TextFormField(
          obscureText: widget.is0bscureText!,
          onChanged: (value) {
            if (value.isEmpty) {
              FocusScope.of(context).previousFocus();
            }
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
          onSaved: widget.onSave,
          style: Theme.of(context).textTheme.headline6,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: "*",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.radius10,
              ),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
          ),
          validator: FormBuilderValidators.compose(widget.validators ?? []),
          controller: widget.textEditingController,
        ),
      ),
    );
  }
}
