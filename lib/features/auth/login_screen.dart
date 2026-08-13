import 'package:flutter/material.dart';

// Corrected imports matching your actual folder structure:
import 'package:mentra_mobile_view/features/auth/user_model.dart';
import 'package:mentra_mobile_view/features/auth/auth_service.dart';
import 'package:mentra_mobile_view/learner/shared/services/storage_service.dart';
// import 'package:mentra_mobile_view/admin/admin_home.dart';
// import 'package:mentra_mobile_view/learner/home/learner_home_screen.dart';
// import 'package:mentra_mobile_view/super_admin/superadmin_home.dart';

class LoginScreen extends StatefulWidget {
  final String? initialError;
  final bool isDemo;

  const LoginScreen({
    super.key,
    this.initialError,
    this.isDemo = true,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authService = AuthService();

  bool _loading = false;
  bool _showPassword = false;
  bool _isDarkMode = false;
  String? _error;
  String? _successMessage;
  Map<String, dynamic> _ssoProviders = {};

  @override
  void initState() {
    super.initState();

    if (widget.initialError != null) {
      _error = widget.initialError;
    }

    if (widget.isDemo) {
      _usernameController.text = 'big_learner';
      _passwordController.text = 'pass';
    }

    _fetchSSOProviders();
  }

  Future<void> _fetchSSOProviders() async {
    final providers = await _authService.getSSOProviders();
    if (mounted) {
      setState(() {
        _ssoProviders = providers;
      });
    }
  }

  Future<void> _handleSubmit() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Please provide your username and password.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _successMessage = null;
    });

    try {
      final UserModel userModel = await _authService.login(username, password);
      await StorageService.setSessionActive(true);

      final displayName = userModel.firstName.isNotEmpty ? userModel.firstName : userModel.username;
      setState(() {
        _successMessage = 'Welcome back, $displayName. Your personalized feed is ready.';
      });

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        final String role = (userModel.role ).toString().toLowerCase();

        if (role == 'superadmin' || role == 'superuser') {
          Navigator.of(context).pushReplacementNamed('/superadmin_home');
        } else {
          Navigator.of(context).pushReplacementNamed('/learner_home');
        }
      }
    } catch (err) {
      if (mounted) {
        setState(() {
          _error = err.toString().replaceAll('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _handleSSO(String provider) {
    _authService.initiateSSO(provider);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFEAF5FD);
    final cardColor = _isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final primaryTextColor = _isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF475569);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Ambient background glows
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            top: 150,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF34D399).withValues(alpha: 0.15),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    children: [
                      // Theme Toggle
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: cardColor.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round_outlined,
                              color: primaryTextColor,
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() {
                                _isDarkMode = !_isDarkMode;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Brand Label
                      const Text(
                        'M E N T R A',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 4.0,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Main Title
                      Text(
                        'Log in to your adaptive learning feed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          letterSpacing: -0.5,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'AI-driven microtrainings update in real time the moment you sign in.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.4,
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Badges
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildPillBadge('1-min microtrainings', const Color(0xFFE0F2FE), const Color(0xFF0369A1)),
                          _buildPillBadge('Quiz-until-mastered', const Color(0xFFDCFCE7), const Color(0xFF15803D)),
                          _buildPillBadge('Live company signals', const Color(0xFFF3E8FF), const Color(0xFF7E22CE)),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Card Form
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                          ),
                          boxShadow: _isDarkMode
                              ? []
                              : [
                                  BoxShadow(
                                    color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'MENTRA ACCESS',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.5,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign in',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: primaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Error Message
                            if (_error != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF1F2),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFFECDD3)),
                                ),
                                child: Text(
                                  _error!,
                                  style: const TextStyle(fontSize: 13, color: Color(0xFFBE123C)),
                                ),
                              ),

                            // Success Message
                            if (_successMessage != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECFDF5),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFA7F3D0)),
                                ),
                                child: Text(
                                  _successMessage!,
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF047857)),
                                ),
                              ),

                            // Username Input
                            Text(
                              'Username',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: primaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _usernameController,
                              enabled: !_loading,
                              style: TextStyle(fontSize: 14, color: primaryTextColor),
                              decoration: InputDecoration(
                                hintText: 'e.g. avery.chen',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                filled: true,
                                fillColor: _isDarkMode ? const Color(0xFF0F172A) : Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Password Input
                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: primaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _passwordController,
                              obscureText: !_showPassword,
                              enabled: !_loading,
                              style: TextStyle(fontSize: 14, color: primaryTextColor),
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                filled: true,
                                fillColor: _isDarkMode ? const Color(0xFF0F172A) : Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: const Color(0xFF94A3B8),
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Submit Button
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _handleSubmit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0284C7),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  _loading ? 'Authenticating...' : 'Sign in to Mentra',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            // Optional SSO Section
                            if (_ssoProviders.containsKey('microsoft') || _ssoProviders.containsKey('google')) ...[
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(child: Divider(color: secondaryTextColor.withValues(alpha: 0.2))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Text(
                                      'OR CONTINUE WITH',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: secondaryTextColor.withValues(alpha: 0.2))),
                                ],
                              ),
                              const SizedBox(height: 14),
                              if (_ssoProviders.containsKey('microsoft'))
                                OutlinedButton.icon(
                                  onPressed: _loading ? null : () => _handleSSO('microsoft'),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(46),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  icon: const Icon(Icons.window, color: Colors.blue, size: 18),
                                  label: const Text('Sign in with Microsoft Entra ID', style: TextStyle(fontSize: 13.5)),
                                ),
                              if (_ssoProviders.containsKey('google')) ...[
                                const SizedBox(height: 10),
                                OutlinedButton.icon(
                                  onPressed: _loading ? null : () => _handleSSO('google'),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(46),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  icon: const Icon(Icons.g_mobiledata, size: 24, color: Colors.red),
                                  label: const Text('Sign in with Google', style: TextStyle(fontSize: 13.5)),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _isDarkMode ? textColor.withValues(alpha: 0.15) : bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _isDarkMode ? textColor.withValues(alpha: 0.9) : textColor,
        ),
      ),
    );
  }
}