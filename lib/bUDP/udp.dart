import 'package:flutter/material.dart';
import 'dart:io';

// ignore: camel_case_types
class udpLoad extends StatefulWidget {
  @override
  _udpLoadState createState() => _udpLoadState();
}

// ignore: camel_case_types
class _udpLoadState extends State<udpLoad> {
  // ignore: unused_element
  void _open() {
    setState(() {
      // ignore: deprecated_member_use

      // ignore: deprecated_member_use
      RawDatagramSocket.bind(InternetAddress.ANY_IP_V4, 0)
          .then((RawDatagramSocket socket) {
        print('Sending from ${socket.address.address}:${socket.port}');
        int port = 4000;
        socket.send('open'.codeUnits, InternetAddress("192.168.205.240"), port);
        socket.receive(); //
        socket.close();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
