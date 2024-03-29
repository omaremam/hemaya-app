import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  final String userId;

  const Messages({Key? key, required this.userId}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Future<List<dynamic>> getSessions(String userId) async {
    final url = Uri.parse(
        "http://13.36.63.83:5956/session"); // Replace with the actual URL

    var data = {
      "userId": userId,
    };

    var reqBody = jsonEncode(data);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: reqBody,
    );

    if (response.statusCode == 200) {
      final List<dynamic> sessionList = json.decode(response.body);

      return sessionList;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30.0),
              child: Image.asset(
                'assets/hemaya.png',
                width: 80,
                height: 80,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: getSessions(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No sessions found.'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var sessionData =
                          snapshot.data![index] as Map<String, dynamic>;

                      return NotificationItem(sessionData: sessionData);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final Map<String, dynamic> sessionData;

  NotificationItem({required this.sessionData});

  String formatTimestamp(Map<String, dynamic> timestamp) {
    int seconds = timestamp['_seconds'];
    int nanoseconds = timestamp['_nanoseconds'];

    // Combine seconds and nanoseconds into a single value
    int combinedMilliseconds =
        (seconds * 1000) + (nanoseconds / 1000000).round();

    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(combinedMilliseconds);

    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();

    // Arabic numerals
    String formattedDate = '$day/$month/$year';

    int hour = dateTime.hour;
    int minute = dateTime.minute;

    // Arabic numerals
    String formattedTime =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

    String formattedDateTime = '$formattedDate $formattedTime';

    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    String text;

    if (sessionData["isAnswered"] == true) {
      text = "و تم الرد عليه و تسجيلة";
    } else {
      text = "و لم يتم الرد عليه";
    }

    return Container(
      color: Colors.white54,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications,
                color: Colors.blue,
                size: 20,
              ),
              SizedBox(height: 5),
              Text(
                "اشعار من المركز",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${formatTimestamp(sessionData["timestamp"])}",
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.right,
                ),
                Wrap(
                  children: [
                    Text(
                      "تم تقديم بلاغ برقم ${sessionData["timestamp"]["_seconds"]} $text",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
