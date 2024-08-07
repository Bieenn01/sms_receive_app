import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsService {
  final SmsQuery _smsQuery = SmsQuery();
  Timer? _timer;

  SmsService() {
    _initialize();
  }

  Future<void> _initialize() async {
    final status = await Permission.sms.request();
    if (status.isGranted) {
      // Start polling for new SMS messages
      _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
        await _pollMessages();
      });
    } else {
      print("SMS permissions are not granted.");
    }
  }

  Future<void> _pollMessages() async {
    try {
      final List<SmsMessage> messages = await _smsQuery.querySms(
        kinds: [SmsQueryKind.inbox],
        sort: false,
        start: 5
      );

      for (SmsMessage message in messages) {
        await _handleIncomingSms(message);
      }
    } catch (e) {
      print("Error fetching SMS messages: $e");
    }
  }

  Future<void> _handleIncomingSms(SmsMessage message) async {
    print("Received SMS: ${message.body}");

    // Save to Firestore
    await FirebaseFirestore.instance.collection('sms_messages').add({
      'body': message.body,
      'sender': message.sender,
      'date': message.date,
    });

    print("SMS saved to Firestore.");
  }

  void dispose() {
    _timer?.cancel();
  }
}
