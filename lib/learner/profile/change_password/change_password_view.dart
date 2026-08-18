import 'package:flutter/material.dart';
import 'change_password_controller.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _controller = ChangePasswordController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _PasswordField(
                    label: 'Current Password',
                    controller: _controller.currentPasswordController,
                    isObscured: _controller.isObscured,
                    onToggle: _controller.toggleVisibility,
                  ),
                  const SizedBox(height: 16),
                  _PasswordField(
                    label: 'New Password',
                    controller: _controller.newPasswordController,
                    isObscured: _controller.isObscured,
                    onToggle: _controller.toggleVisibility,
                  ),
                  const SizedBox(height: 16),
                  _PasswordField(
                    label: 'Confirm New Password',
                    controller: _controller.confirmPasswordController,
                    isObscured: _controller.isObscured,
                    onToggle: _controller.toggleVisibility,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(
                          flex: 4, //cancel gets 3/8 of space
                          child: OutlinedButton(
                              onPressed: _controller.resetFields,
                              child: const Text('Cancel'),
                            ),
                        ),
                        
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 5, //change password get 5/8 of space
                              child: ElevatedButton(
                              onPressed: _controller.isLoading
                                  ? null
                                  : () async {
                                      bool success = await _controller.submitPasswordChange();
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              success
                                                  ? 'Password changed successfully!'
                                                  : 'Passwords do not match or failed.',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF38BDF8),
                        ),
                        child: const Text('Confirm'),
                      ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isObscured;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.isObscured,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}