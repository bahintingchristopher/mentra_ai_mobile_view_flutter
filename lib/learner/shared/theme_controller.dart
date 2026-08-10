import 'package:flutter/material.dart';

// Global notifier accessible across the entire app
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);