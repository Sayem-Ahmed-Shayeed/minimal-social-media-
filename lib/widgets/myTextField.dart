import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media/provider/confirm_passwrod_provider.dart';
import 'package:social_media/provider/email_provider.dart';
import 'package:social_media/provider/name_provider.dart';
import 'package:social_media/provider/password_provider.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final bool shouldBeObscure;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.shouldBeObscure,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    bool isHidden = true;
    return Consumer(
      builder: (context, ref, child) {
        return TextField(
          obscureText: widget.shouldBeObscure,
          onChanged: (value) {
            (widget.hintText == 'Password')
                ? ref
                    .watch(PasswordProviderNotifierProvider.notifier)
                    .updatePassword(value)
                : (widget.hintText == 'Email')
                    ? ref
                        .watch(EmailNotifierProvider.notifier)
                        .updateEmail(value)
                    : (widget.hintText == 'Name')
                        ? ref
                            .watch(nameNotifierProvider.notifier)
                            .updateName(value)
                        : ref
                            .watch(ConfirmPasswrodNotifierProvider.notifier)
                            .updateConfirmPassword(value);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
            ),
          ),
        );
      },
    );
  }
}
