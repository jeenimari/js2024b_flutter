// widgets/password_dialog.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';

class PasswordDialog extends StatefulWidget {
  final String title;
  final String message;
  final Function(String) onConfirm;

  const PasswordDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.message),
          const SizedBox(height: 16.0),
          TextField(
            controller: _passwordController,
            obscureText: _isObscure,
            decoration: InputDecoration(
              hintText: '비밀번호 입력',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('취소'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('확인'),
          onPressed: () {
            if (_passwordController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('비밀번호를 입력해주세요.'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
              return;
            }
            widget.onConfirm(_passwordController.text);
          },
        ),
      ],
    );
  }
}