import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  const AuthFormField({
    super.key,
    required TextEditingController controller,
    required String labelText,
    this.validator,
  })  : _controller = controller,
        _labelText = labelText;

  final TextEditingController _controller;
  final String _labelText;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: _labelText),
      controller: _controller,
      validator: validator,
    );
  }
}
