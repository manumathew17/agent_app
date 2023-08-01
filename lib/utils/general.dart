import 'package:audioplayers/audioplayers.dart';
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
      Vibration.vibrate(duration: 1000);
      FlutterRingtonePlayer.play(fromAsset: "assets/audio/alarm.mp3");

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

  static Future<bool> openWhatsApp(String phoneNumber, String message) async {
    String encodedMessage = Uri.encodeComponent(message);
    String url = 'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}';
    return await launchUrl(Uri.parse(url));
  }

  static String formatDateTime(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      String formattedDate = DateFormat('dd-MM-yy').format(dateTime);
      String formattedTime = DateFormat('hh:mm a').format(dateTime);
      return '$formattedDate $formattedTime';
    } catch (_) {
      return "NA";
    }
  }
}
