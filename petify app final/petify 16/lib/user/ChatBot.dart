
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});

  final String title;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = []; // Updated to store sender & message

  // Send message to chatbot API
  Future<void> _sendMessage() async {
    String userMessage = _controller.text;

    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"sender": "You", "message": userMessage});
      _controller.clear();
    });

    try {
      final pref = await SharedPreferences.getInstance();
      String urls = pref.getString('url').toString();
      String url = '$urls/myapp/chatbot/';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': userMessage}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String geminiResponse = data['response'];
        setState(() {
          _messages.add({"sender": "Gemini", "message": geminiResponse});
        });
      } else {
        setState(() {
          _messages.add({"sender": "Gemini", "message": "Sorry, something went wrong."});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"sender": "Gemini", "message": "Error occurred while connecting to the server."});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.brown.shade400, // Updated color for a more modern feel
      ),
      body: Column(
        children: [
          // Chat message list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message['sender'] == "You";

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.brown.shade400 : Colors.brown.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        message['message']!,
                        style: TextStyle(
                          color: isUserMessage ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input field and send button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.brown.shade400),
                  onPressed: _sendMessage,
                  iconSize: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}