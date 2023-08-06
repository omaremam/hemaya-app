import 'package:flutter/material.dart';
import 'call_screen.dart';
import '../services/signalling.service.dart';

class JoinScreen extends StatefulWidget {
  final String selfCallerId;
  final String name;
  late double? lat;
  late double? long;

  JoinScreen(
      {super.key,
      required this.selfCallerId,
      required this.name,
      required this.lat,
      required this.long});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  dynamic incomingSDPOffer;
  final remoteCallerIdTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // join Call
  _joinCall({
    required String callerId,
    required String calleeId,
    required String name,
    required double? lat,
    required double? long,
    dynamic offer,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => CallScreen(
              callerId: callerId,
              calleeId: calleeId,
              offer: offer,
              lat: lat,
              long: long,
              name: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.white30),
                  ),
                  child: const Text(
                    "بدء البث",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    _joinCall(
                        callerId: widget.selfCallerId,
                        calleeId: "1234",
                        name: widget.name,
                        lat: widget.lat,
                        long: widget.long);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
