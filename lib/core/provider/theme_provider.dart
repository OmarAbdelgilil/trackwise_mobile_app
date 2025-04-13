import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void toggleTheme() {
    if(state == ThemeMode.system)
    {
      var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      state = isDarkMode ? ThemeMode.light : ThemeMode.dark;
      return ;
    }
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  bool isDark(Brightness platformBrightness) {
    if (state == ThemeMode.system) {
      return platformBrightness == Brightness.dark;
    } else {
      return state == ThemeMode.dark;
    }
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);
