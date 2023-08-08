import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class GeneralUtils {
  static bool isValidEmail(String value) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
    );
    return emailRegExp.hasMatch(value);
  }

  static notificationVibrate() async {
    try {
      Vibration.vibrate(duration: 5000);
      FlutterRingtonePlayer.play(fromAsset: "assets/audio/alarm.mp3",asAlarm: true);
    } catch (e) {
      print('Error vibrate : $e');
    }
  }

  static makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  static String readableTime(String dateString) {
    try {
      List<String> dateParts = dateString.split(' ');
      String timeString = dateParts[4];
      DateTime jsDateTime = DateTime.parse("1970-01-01 $timeString");
      String humanReadableTime = DateFormat("h:mm:ss a").format(jsDateTime);
      return humanReadableTime;
    } catch (_) {
      return "";
    }
  }

  static copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  static String getTime(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      String formattedTime = DateFormat.jm().format(dateTime);

      return formattedTime;
    } catch (ex) {
      print(ex.toString());
      return "NA";
    }
  }

  static String convertUtcToLocal(String utcTimeString) {
    // Parse the UTC time string to DateTime object
    DateTime utcTime = DateTime.parse(utcTimeString);

    // Get the device's local time zone
    String localTimeZone = DateTime.now().timeZoneOffset.toString();

    // Calculate the offset in hours and minutes
    int offsetHours = int.parse(localTimeZone.split(':')[0]);
    int offsetMinutes = int.parse(localTimeZone.split(':')[1]);

    // Apply the offset to get the local time
    DateTime localTime = utcTime.add(Duration(hours: offsetHours, minutes: offsetMinutes));

    // Format the local time to the desired format "dd-mm hh:mm a"
    String formattedTime = DateFormat('dd-MM hh:mm a').format(localTime);
    return formattedTime;
  }

  static String formatDateTime(String timestamp) {
    print(timestamp);
    try {
      DateTime parsedDateTime = DateTime.parse(timestamp);

      DateTime localDateTime = parsedDateTime.toLocal();

      String formattedDateTime = DateFormat('dd-MMM hh:mm a').format(localDateTime);

      return formattedDateTime;
    } catch (_) {
      return "NA";
    }
  }

  static Future<bool> openWhatsApp(String phoneNumber, String message) async {
    print(phoneNumber);
    String url = 'whatsapp://send?phone=91$phoneNumber}';
    return await launchUrl(Uri.parse(url));
  }

  // static String formatDateTime(String dateTimeString) {
  //   try {
  //     DateTime dateTime = DateTime.parse(dateTimeString);
  //     String formattedDate = DateFormat('dd-MM').format(dateTime);
  //     String formattedTime = DateFormat('hh:mm a').format(dateTime);
  //     return '$formattedDate $formattedTime';
  //   } catch (_) {
  //     return "NA";
  //   }
  // }

  static TimeOfDay intToTimeOfDay(int hours) {
    try {
      final int hour = hours % 24;
      final TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: 0);
      return timeOfDay;
    } catch (_) {
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }
}
