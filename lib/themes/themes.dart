import 'package:flutter/material.dart';
import 'package:yoya/utils/utils.dart';

ThemeData themeData = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Utils.darkColorBackground,
  iconTheme: IconThemeData(size: Utils.iconSize, color: Utils.lightColorGreen),
  floatingActionButtonTheme: FloatingActionButtonThemeData(iconSize: 40, backgroundColor: Utils.lightColorGreen, foregroundColor: Utils.darkColorGreen, splashColor: Utils.lightColorBackground),
  splashColor: Utils.lightColorBackground,
  //SNACKBAR
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Utils.lightColorBackground,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Utils.lightColorBackground, // Color del cursor
    selectionColor: Utils.darkColorGreen, // Color de la selección del texto
    selectionHandleColor: Utils.lightColorBackground, // Color del indicador al seleccionar
  ),
  //TEXTFIELD
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Utils.lightColorGreen, fontFamily: Utils.fontFamilyName),
    labelStyle: TextStyle(color: Utils.lightColorGreen, fontFamily: Utils.fontFamilyName),
    suffixIconColor: Utils.lightColorGreen,
    prefixIconColor: Utils.lightColorGreen,
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Utils.lightColorGreen), borderRadius: BorderRadius.circular(20)),
    border: OutlineInputBorder(borderSide: BorderSide(color: Utils.lightColorGreen), borderRadius: BorderRadius.circular(20)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Utils.lightColorGreen), borderRadius: BorderRadius.circular(20)),
    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Utils.lightColorGreen), borderRadius: BorderRadius.circular(20)),
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
      backgroundColor: WidgetStateProperty.resolveWith((states) => Utils.darkColorGreen),
      overlayColor: WidgetStateProperty.resolveWith((states) => Utils.lightColorBackground),
    ),
  ),
  //ACEPTAR
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      overlayColor: WidgetStateProperty.resolveWith((states) => Utils.lightColorBackground),
      foregroundColor: WidgetStateProperty.resolveWith((states) => Utils.darkColorBackground),
      backgroundColor: WidgetStateProperty.resolveWith((states) => Utils.lightColorGreen),
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
        return Utils.darkColorGreen;
      } else if (states.contains(WidgetState.disabled)) {
        return Utils.darkColorBackground;
      } else {
        return Utils.lightColorGreen;
      }
    }),
    todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Utils.lightColorBackground;
      } else {
        return Utils.darkColorGreen;
      }
    }),
    todayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Utils.darkColorGreen;
      } else {
        return Utils.lightColorGreen;
      }
    }),
    dividerColor: Utils.darkColorBackground,
    headerBackgroundColor: Utils.darkColorBackground,
    headerForegroundColor: Utils.lightColorBackground,
    confirmButtonStyle: ButtonStyle(overlayColor: WidgetStateProperty.all(Utils.lightColorBackground), foregroundColor: WidgetStateProperty.all(Utils.darkColorGreen)),
    cancelButtonStyle: ButtonStyle(overlayColor: WidgetStateProperty.all(Utils.lightColorBackground), foregroundColor: WidgetStateProperty.all(Utils.darkColorGreen)),
    backgroundColor: Utils.darkColorBackground,
    dayStyle: Utils.normalStyle15,
    headerHeadlineStyle: Utils.normalStyle20,
    yearStyle: Utils.normalStyle20,
    headerHelpStyle: Utils.normalStyle20,
    weekdayStyle: Utils.normalStyle20.copyWith(color: Utils.lightColorBackground),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: Utils.lightColorBackground, linearTrackColor: Utils.lightColorBackground, circularTrackColor: Utils.lightColorBackground),
);

//  if (states.contains(WidgetState.selected)) {
//           return Utils.darkColorBackground;
//         } else {
//           return Utils.lightColorBackground;
//         }
