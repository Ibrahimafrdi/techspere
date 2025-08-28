import 'package:flutter/material.dart';
import '../../core/constant/color.dart';

class CustomTextField extends StatelessWidget {
  final onChanged;
  final validator;
  final labelText;
  final controller;
  final preFixIcon;
  final maxLine;
  final hintText;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final bool readOnly;
  final textInputAction;
  final keyboardType;
  final IconButton? suffixIcon;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final bool isMultiline;
  final TextAlign textAlign;
  final inputFormatters;

  CustomTextField({
    this.isMultiline = false,
    this.preFixIcon,
    this.maxLine = 1,
    this.hintText,
    this.readOnly = false,
    this.autofillHints,
    this.onChanged,
    this.controller,
    this.labelText,
    this.validator,
    this.obscureText = false,
    this.textInputAction,
    this.keyboardType,
    this.suffixIcon,
    this.focusNode,
    this.onFieldSubmitted,
    EdgeInsets? contentPadding,
    this.textAlign = TextAlign.center,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      controller: controller,
      maxLines: maxLine,
      obscureText: obscureText,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      onFieldSubmitted: onFieldSubmitted,
      textAlign: textAlign,
      decoration: InputDecoration(
          labelText: labelText,
          floatingLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: primaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
          labelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          enabledBorder: OutlineInputBorder(
            // borderSide: BorderSide(color: borderColor, width: 1),
            borderSide: const BorderSide(color: Color(0xff000000), width: 1),
            borderRadius: BorderRadius.circular(7),
          ),
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1),
            borderRadius: BorderRadius.circular(7),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffF7658B), width: 1),
            borderRadius: BorderRadius.circular(7),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffF7658B), width: 1),
            borderRadius: BorderRadius.circular(7),
          ),
          errorStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xffF7658B),
          ),
          suffixIcon: suffixIcon,
          prefixIcon: preFixIcon),
    );
  }
}
