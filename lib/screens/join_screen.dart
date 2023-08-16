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
      body: Container(
        color: Color.fromRGBO(234, 234, 234, 1),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Image.asset(
                    'assets/hemaya.png',
                    width: 90,
                    height: 90,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(color: Colors.black45, fontSize: 18),
                      ),
                      Container(
                          margin: EdgeInsets.only(right: 5, left: 5),
                          width: 45,
                          height: 45,
                          child: Image.asset("assets/profile.png")),
                      Icon(
                        Icons.menu,
                        color: Color.fromRGBO(10, 144, 163, 1),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF009F98), Color(0xFF1281AE)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 100),
                padding: const EdgeInsets.only(top: 20, bottom: 160),
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        width: 250,
                        height: 50,
                        margin: EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(242, 242, 242, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                opacity: 0,
                                child: Icon(Icons.arrow_forward),
                              ),
                              Text(
                                'البلاغات المغلقة',
                                style: TextStyle(color: Colors.black),
                              ),
                              Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    "assets/newdoc.png",
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 50,
                        margin: EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(242, 242, 242, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                opacity: 0,
                                child: Icon(Icons.arrow_forward),
                              ),
                              Text(
                                'البلاغات المغلقة',
                                style: TextStyle(color: Colors.black),
                              ),
                              Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    "assets/hold.png",
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 50,
                        margin: EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(242, 242, 242, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                opacity: 0,
                                child: Icon(Icons.arrow_forward),
                              ),
                              Text(
                                'البلاغات المغلقة',
                                style: TextStyle(color: Colors.black),
                              ),
                              Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    "assets/complete.png",
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 50,
                        margin: EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(242, 242, 242, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                opacity: 0,
                                child: Icon(Icons.arrow_forward),
                              ),
                              Text(
                                'تسجيل الخروج',
                                style: TextStyle(color: Colors.black),
                              ),
                              Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    "assets/logout.png",
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
