import 'package:flutter/material.dart';
import 'package:qixer/view/utils/responsive.dart';

import 'constant_colors.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validation;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  final FocusNode? focusNode;
  final bool isNumberField;
  final String? icon;
  final double paddingHorizontal;
  final maxLength;
  final Iterable<String>? autofillHints;

  TextEditingController? controller;

  CustomInput({
    super.key,
    required this.hintText,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.isPasswordField = false,
    this.focusNode,
    this.isNumberField = false,
    this.controller,
    this.validation,
    this.icon,
    this.paddingHorizontal = 8.0,
    this.maxLength,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            // color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          controller: controller,
          keyboardType:
              isNumberField ? TextInputType.number : TextInputType.text,
          focusNode: focusNode,
          onChanged: onChanged,
          validator: validation,
          textInputAction: textInputAction,
          obscureText: isPasswordField,
          maxLength: maxLength,
          autofillHints: autofillHints,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
              prefixIcon: icon != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 22.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(icon!),
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                      ],
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ConstantColors().greyFive),
                  borderRadius: BorderRadius.circular(9)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ConstantColors().primaryColor)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ConstantColors().warningColor)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ConstantColors().primaryColor)),
              hintText: lnProvider.getString(hintText),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: paddingHorizontal, vertical: 18)),
        ));
  }
}
