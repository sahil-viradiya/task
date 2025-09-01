import 'dart:convert';

import 'package:flutter/Material.dart'; // For jsonEncode and JsonEncoder

enum Logger {
  black("30"),
  red("31"),
  green("32"),
  blue("34"),
  magenta("35"),
  cyan("36"),
  white("37"),
  brightBlack("90"),
  brightRed("91"),
  brightGreen("92"),
  brightBlue("94"),
  brightMagenta("95"),
  brightCyan("96"),
  brightWhite("97");

  final String code;
  const Logger(this.code);

  // Logs regular text in color
  void log(dynamic text) =>
      debugPrint('\x1B[${code}m$text\x1B[0m');

  // Logs JSON in a readable, pretty format
  void logJson(dynamic jsonResponse) {
    // If it's not a Map or List, print it as it is
    if (jsonResponse is! Map && jsonResponse is! List) {
      log(jsonResponse);
      return;
    }

    // Pretty print JSON using a JsonEncoder
    var encoder = JsonEncoder.withIndent('  '); // Indentation with 2 spaces
    String prettyJson = encoder.convert(jsonResponse);
    log(prettyJson);
  }
}
