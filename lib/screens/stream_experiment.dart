import 'dart:async';

import 'package:flutter/material.dart';


class ChatToDemoStream extends StatelessWidget {
  static String id = "8";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chat Example with Stream'),
        ),
        body: StreamBuilderDemo(),
      ),
    );
  }
}

class StreamBuilderDemo extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<StreamBuilderDemo> {
  final StreamController<String> _messageStreamController = StreamController<String>();

  @override
  void dispose() {
    _messageStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: _messageStreamController.stream,
            builder: (context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                // Assuming each message is a string for simplicity
                List<String> messages = snapshot.data?.split('\n') ?? [];
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(messages[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Simulating message deletion
                          setState(() {
                            messages.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        // A button to simulate new messages from the server
        ElevatedButton(
          onPressed: () {
            // Simulating new messages from the server
            _messageStreamController.add('New message at ${DateTime.now()}');
          },
          child: Text('Simulate New Message'),
        ),
      ],
    );
  }
}
