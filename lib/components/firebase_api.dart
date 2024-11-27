import 'package:firebase_messaging/firebase_messaging.dart';

//דף נסיון NOTIFICATION
class FirebaseApi{
  final _firebaseM= FirebaseMessaging.instance;

  Future<void>handleBackgroundMessage(RemoteMessage message) async{
    print('title: ${message.notification?.title}');
    print('body: ${message.notification?.body}');
    print('payload: ${message.data}');

  }
  Future<void> initNotification()async{
    await _firebaseM.requestPermission(); //אישור של היוזר לשלוח הודעות
    final FCMToken = await _firebaseM.getToken();
    print('token: $FCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}