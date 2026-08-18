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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDark
                    ? const Color(0xFF334155)
                    : Colors.grey.shade200,
              ),
            ),
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _PasswordField(
                    label: 'Current Password',
                    controller: _controller.currentPasswordController,
                    isObscured: _controller.isObscured,
                    onToggle: _controller.toggleVisibility,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _PasswordField(
                    label: 'New Password',
                    controller: _controller.newPasswordController,
                    isObscured: _controller.isObscured,
                    onToggle: _controller.toggleVisibility,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _PasswordField(
                    label: 'Confirm New Password',
                    controller: _controller.confirmPasswordController,
                    isObscured: _controller.isObscured,
                    onToggle: _controller.toggleVisibility,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: OutlinedButton(
                          onPressed: _controller.resetFields,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFFCBD5E1),
                            ),
                            foregroundColor: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 5,
                        child: ElevatedButton(
                          onPressed: _controller.isLoading
                              ? null
                              : () async {
                                  bool success =
                                      await _controller.submitPasswordChange();
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
                            backgroundColor: isDark
                                ? const Color.fromARGB(255, 30, 49, 94)
                                : const Color(0xFF38BDF8),
                            foregroundColor: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
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
  final bool isDark;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.isObscured,
    required this.onToggle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFCBD5E1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFCBD5E1),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF38BDF8), width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}