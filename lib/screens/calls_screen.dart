import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallsScreen extends StatefulWidget {
  final String userId;
  final bool isAnswered;

  const CallsScreen({Key? key, required this.userId, required this.isAnswered})
      : super(key: key);

  @override
  _CallsScreenState createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  Future<List<QueryDocumentSnapshot>> getSessions() async {
    try {
      // Fetch sessions based on userId and isAnswered conditions
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("sessions").get();

      print(snapshot.docs);

      return snapshot.docs;
    } catch (e) {
      // Handle errors
      print('Error fetching sessions: $e');
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
              child: FutureBuilder<List<QueryDocumentSnapshot>>(
                future: getSessions(),
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
                          snapshot.data![index].data() as Map<String, dynamic>;

                      // Use your session data here to build the list item
                      return ListTile(
                        title: Text("asdasdasd"),
                        subtitle: Text(sessionData['timestamp'].toString()),
                      );
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
