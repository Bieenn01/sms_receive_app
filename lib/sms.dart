import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class SmsReceiver extends StatefulWidget {
  const SmsReceiver({Key? key}) : super(key: key);

  @override
  State<SmsReceiver> createState() => _SmsReceiverState();
}

class _SmsReceiverState extends State<SmsReceiver> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeSmsPermission();
  }

  Future<void> _initializeSmsPermission() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      await _fetchAndSaveSms();
    } else {
      if (await Permission.sms.request().isGranted) {
        await _fetchAndSaveSms();
      }
    }
  }

  Future<void> _fetchAndSaveSms() async {
    final messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
      count: 10,
    );

    setState(() => _messages = messages);

    for (var message in messages) {
      await _saveSmsToFirestore(message);
    }
  }

  Future<void> _saveSmsToFirestore(SmsMessage message) async {
    try {
      await FirebaseFirestore.instance.collection('sms_messages').add({
        'body': message.body,
        'sender': message.sender,
        'date': message.date?.toUtc(),
      });
      print('SMS saved to Firestore: ${message.body}');
      print('SMS saved to Firestore: ${message.sender}');
    } catch (e) {
      print('Failed to save SMS to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SMS Inbox App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SMS Inbox Example'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: _messages.isNotEmpty
              ? _MessagesListView(messages: _messages)
              : Center(
                  child: Text(
                    'No messages to show.\n Tap refresh button...',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _fetchAndSaveSms();
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class _MessagesListView extends StatelessWidget {
  const _MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int i) {
        var message = messages[i];

        return ListTile(
          title: Text('${message.sender} [${message.date}]'),
          subtitle: Text('${message.body}'),
        );
      },
    );
  }
}
