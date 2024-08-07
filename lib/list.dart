import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: SingleChildScrollView(
            physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 230, 225, 225),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      width: 2, color: Color.fromARGB(255, 179, 153, 153)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/app-info');
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.settings,
                                      size: 50, color: Colors.blue),
                                  SizedBox(height: 8),
                                  Text('App Info',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/sms-receiver');
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.message_rounded,
                                      size: 50, color: Colors.blue),
                                  SizedBox(height: 8),
                                  Text('SMS Receiver',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
