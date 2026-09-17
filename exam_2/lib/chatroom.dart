import 'package:flutter/material.dart';
import 'profile.dart';

class ChatroomScreen extends StatefulWidget {
  final Convo convo;

  const ChatroomScreen({super.key, required this.convo});

  @override
  State<ChatroomScreen> createState() => ChatroomState();
}

class ChatroomState extends State<ChatroomScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 13, 14),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 16, 13, 14),
        elevation: 0,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,

              decoration: BoxDecoration(
                color: Color.fromARGB(255, 36, 33, 34),
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.person,
                color: (widget.convo.online ?? false)
                    ? Color.fromARGB(255, 255, 70, 85)
                    : Colors.white,
                size: 25,
              ),
            ),

            SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.convo.name ?? 'Unknown User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  widget.convo.online ?? false
                      ? 'Online - VALORANT'
                      : 'Away - Riot Mobile',
                  style: TextStyle(
                    color: Color.fromARGB(255, 130, 127, 128),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          Icon(Icons.more_horiz, color: Colors.white),

          SizedBox(width: 15),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(15),

              children: [
                if ((widget.convo.message ?? '').isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,

                    child: Container(
                      padding: EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 36, 32, 33),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Text(
                        widget.convo.message ?? 'No message available.',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,

                    style: TextStyle(color: Colors.white),

                    decoration: InputDecoration(
                      hintText: 'Send a message',

                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 130, 127, 128),
                      ),

                      filled: true,

                      fillColor: Color.fromARGB(255, 36, 32, 33),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
