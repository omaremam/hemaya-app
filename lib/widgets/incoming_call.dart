import 'package:flutter/material.dart';
import 'package:hemaya/providers/call_state.dart';
import 'package:hemaya/screens/call_screen.dart';
import 'package:provider/provider.dart';

class IncomingCall extends StatefulWidget {
  final dynamic offer;
  const IncomingCall({super.key, required this.offer});

  @override
  State<IncomingCall> createState() => _IncomingCallState();
}

class _IncomingCallState extends State<IncomingCall> {
  dynamic callOffer;

  @override
  void initState() {
    super.initState();
    callOffer = widget.offer;
    if (mounted) {
      print("IncomingCall Widget");
      print(widget.offer != null);
    }
  }

  @override
  void dispose() {
    // Dispose of any resources if needed
    super.dispose();
  }

  _navigateToCallScreen(offer){
        Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => CallScreen(
                callerId: offer["callerId"],
                calleeId: offer["sdpOffer"]["call_key"],
                offer: offer,
                lat: 0,
                long: 0,
                name: "Hemaya Admin",
                userId: offer["callerId"],
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        width: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Incoming Call"),
            IconButton(
              icon: const Icon(Icons.call_end),
              color: Colors.redAccent,
              onPressed: () {
                context.read<CallState>().clearIncomingCall();
              },
            ),
            IconButton(
              icon: const Icon(Icons.call),
              color: Colors.greenAccent,
              onPressed: () {
                _navigateToCallScreen(widget.offer);
              },
            ),
          ],
        ),
      ),
    );
  }
}
