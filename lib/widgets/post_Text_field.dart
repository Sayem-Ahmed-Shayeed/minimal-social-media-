import 'package:flutter/material.dart';

class PostTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;

  const PostTextField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  State<PostTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<PostTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 1,
      maxLines: 5,
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Theme.of(context)
              .colorScheme
              .inversePrimary
              .withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
