import 'package:flutter/material.dart';
import 'package:yoya/utils/utils.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.dark(primary: Utils.lightColorBackground, onPrimary: Utils.darkColorSecond),
  scaffoldBackgroundColor: Utils.darkColorBackground,
  iconTheme: IconThemeData(size: Utils.iconSize, color: Utils.lightColorSecond),
  floatingActionButtonTheme: FloatingActionButtonThemeData(iconSize: 40, backgroundColor: Utils.lightColorSecond, foregroundColor: Utils.darkColorSecond, splashColor: Utils.lightColorBackground),
  splashColor: Utils.lightColorBackground,
  //SNACKBAR
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Utils.lightColorBackground,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Utils.lightColorBackground, // Color del cursor
    selectionColor: Utils.darkColorSecond, // Color de la selección del texto
    selectionHandleColor: Utils.lightColorBackground, // Color del indicador al seleccionar
  ),
  //TEXTFIELD
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Utils.lightColorSecond, fontFamily: Utils.fontFamilyName),
    labelStyle: TextStyle(color: Utils.lightColorSecond, fontFamily: Utils.fontFamilyName),
    suffixIconColor: Utils.lightColorSecond,
    prefixIconColor: Utils.lightColorSecond,
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Utils.lightColorSecond), borderRadius: BorderRadius.circular(20)),
    border: OutlineInputBorder(borderSide: BorderSide(color: Utils.lightColorSecond), borderRadius: BorderRadius.circular(20)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Utils.lightColorSecond), borderRadius: BorderRadius.circular(20)),
    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Utils.lightColorSecond), borderRadius: BorderRadius.circular(20)),
  ),
  //CANCELAR
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Utils.darkColorBackground;
        } else {
          return Utils.lightColorBackground;
        }
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) => Utils.darkColorSecond),
      overlayColor: WidgetStateProperty.resolveWith((states) => Utils.lightColorBackground),
    ),
  ),
  //ACEPTAR
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      overlayColor: WidgetStateProperty.resolveWith((states) => Utils.lightColorBackground),
      foregroundColor: WidgetStateProperty.resolveWith((states) => Utils.darkColorBackground),
      backgroundColor: WidgetStateProperty.resolveWith((states) => Utils.lightColorSecond),
    ),
  ),
  //DATEPICKER
  datePickerTheme: DatePickerThemeData(
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Utils.lightColorBackground;
      } else {
        return Utils.darkColorBackground;
      }
    }),
    dayOverlayColor: WidgetStateProperty.all(Utils.lightColorBackground),
    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Utils.darkColorSecond;
      } else if (states.contains(WidgetState.disabled)) {
        return Utils.darkColorBackground;
      } else {
        return Utils.lightColorSecond;
      }
    }),
    todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Utils.lightColorBackground;
      } else {
        return Utils.darkColorSecond;
      }
    }),
    todayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Utils.darkColorSecond;
      } else {
        return Utils.lightColorSecond;
      }
    }),
    dividerColor: Utils.darkColorBackground,
    headerBackgroundColor: Utils.darkColorBackground,
    headerForegroundColor: Utils.lightColorBackground,
    confirmButtonStyle: ButtonStyle(overlayColor: WidgetStateProperty.all(Utils.lightColorBackground), foregroundColor: WidgetStateProperty.all(Utils.darkColorSecond)),
    cancelButtonStyle: ButtonStyle(overlayColor: WidgetStateProperty.all(Utils.lightColorBackground), foregroundColor: WidgetStateProperty.all(Utils.darkColorSecond)),
    backgroundColor: Utils.darkColorBackground,
    dayStyle: Utils.normalStyle15,
    headerHeadlineStyle: Utils.normalStyle20,
    yearStyle: Utils.normalStyle20,
    headerHelpStyle: Utils.normalStyle20,
    weekdayStyle: Utils.normalStyle20.copyWith(color: Utils.lightColorBackground),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  //PROGRESS
  progressIndicatorTheme: ProgressIndicatorThemeData(color: Utils.lightColorBackground, linearTrackColor: Utils.lightColorBackground, circularTrackColor: Utils.lightColorBackground),
  //SWITCH
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Utils.lightColorSecond;
      } else {
        return Utils.darkColorSecond;
      }
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Utils.lightColorBackground;
      } else {
        return Utils.darkColorBackground;
      }
    }),
  ),
  //TIMEPICKER
  timePickerTheme: TimePickerThemeData(
    backgroundColor: Utils.darkColorBackground,
    helpTextStyle: Utils.bigTitleStyle,
    hourMinuteColor: Utils.darkColorSecond,
    hourMinuteTextColor: Utils.lightColorBackground,
    hourMinuteTextStyle: Utils.normalStyle30.copyWith(fontSize: 70),
    dialHandColor: Utils.lightColorSecond,
    dialBackgroundColor: Utils.darkColorSecond,
    dialTextStyle: Utils.normalStyle20,
    timeSelectorSeparatorColor: WidgetStateProperty.all(Utils.lightColorSecond),
    confirmButtonStyle: ButtonStyle(overlayColor: WidgetStateProperty.all(Utils.lightColorBackground), foregroundColor: WidgetStateProperty.all(Utils.darkColorSecond)),
    cancelButtonStyle: ButtonStyle(overlayColor: WidgetStateProperty.all(Utils.lightColorBackground), foregroundColor: WidgetStateProperty.all(Utils.darkColorSecond)),
  ),
);
