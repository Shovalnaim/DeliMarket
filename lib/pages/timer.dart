import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:markettest/HomePage.dart';
import 'package:markettest/pages/Auth/Login_page.dart';

class timer extends StatefulWidget {
  const timer(
      {
        super.key,
        required this.deadline,
        required this.initialDuration, // New parameter for initial duration
        this.textStyle,
        this.labletextstyle
      });

  final DateTime deadline;
  final Duration initialDuration; // New field for initial duration
  final TextStyle? textStyle;
  final TextStyle? labletextstyle;

  @override
  State<timer> createState() => _timerState();
}

class _timerState extends State<timer> {
  late Timer time;
 Duration duration = const Duration();


  @override
  void initState() {
    super.initState();
    calculateTimeLeft(); // Calculate the initial duration difference
    startTimer(); // Start the timer
  }



  @override
  Widget build(BuildContext context) {
    var textStyle =
        widget.textStyle ?? Theme.of(context).textTheme.headlineLarge!;
    var lableTextStyle =
        widget.labletextstyle ?? Theme.of(context).textTheme.bodyMedium!;

    final hours = DefaultTextStyle(
        style: textStyle,
        child: Text(
          duration.inHours.toString().padLeft(2, '0'),
        ));
    final minuts = DefaultTextStyle(
        style: textStyle,
        child: Text(
          duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        ));
    final seconds = DefaultTextStyle(
        style: textStyle,
        child:
        Text(duration.inSeconds.remainder(60).toString().padLeft(2, '0')));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(colors: [
                //Color(0XFF1C4386B5),
                Colors.black,
                Colors.black
              ]).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: hours,
              ),
            ),
            DefaultTextStyle(style: lableTextStyle, child: Text('Hours')),
          ],
        ),
        SizedBox(
          width: 16,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(colors: [
                //Color(0XFF1C4386B5),
                Colors.black,
                Colors.black
              ]).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: minuts,
              ),
            ),
            DefaultTextStyle(style: lableTextStyle, child: Text('Minutes')),
          ],
        ),
        SizedBox(
          width: 16,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(colors: [
                //   Color(0XFF1C4386B5),
                Colors.black,
                Colors.black
              ]).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: seconds,
              ),
            ),
            DefaultTextStyle(style: lableTextStyle, child: Text('Seconds')),
          ],
        ),
        SizedBox(
          width: 16,
        )
      ],
    );
  }


//Duration initialDuration  DateTime deadline
  void calculateTimeLeft() {
    print("wid.deadlineee: "+widget.deadline.toString());
    final seconds = widget.deadline.difference(DateTime.now()).inSeconds;
    setState(() {
      duration = Duration(seconds: seconds);
      print("duration: "+duration.toString());
    });
  }

//   This method starts a periodic timer that decrements the duration every second until it reaches zero.
//   Once the duration reaches zero, the timer is canceled.
  void startTimer() {
    time = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (duration.inSeconds > 0) {
          duration -= Duration(seconds: 1); // Countdown by 1 second
        } else {
          time.cancel(); // Stop the timer when duration reaches 0
        }
      });
    });
  }
}