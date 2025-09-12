import 'package:flutter/material.dart';

enum InputFieldType { text, number, email, password, area }

class CustomInputField extends StatefulWidget {
  final String label;
  final String? hintText;
  final InputFieldType type;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomInputField({
    super.key,
    required this.label,
    this.hintText,
    this.type = InputFieldType.text,
    this.controller,
    this.onChanged,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType;
    int maxLines = 1;

    switch (widget.type) {
      case InputFieldType.number:
        keyboardType = TextInputType.number;
        break;
      case InputFieldType.email:
        keyboardType = TextInputType.emailAddress;
        break;
      case InputFieldType.area:
        keyboardType = TextInputType.multiline;
        maxLines = 5;
        break;
      case InputFieldType.password:
        keyboardType = TextInputType.text;
        break;
      default:
        keyboardType = TextInputType.text;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: widget.type == InputFieldType.password ? _obscure : false,
        keyboardType: keyboardType,
        maxLines: widget.type == InputFieldType.area ? maxLines : 1,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: widget.type == InputFieldType.password
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
