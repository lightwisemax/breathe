import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibrate/vibrate.dart';
import 'package:breathe/breathe.dart';
import 'package:breathe/settings.dart';
import 'package:breathe/variables.dart';
import 'package:breathe/functions.dart';
import 'package:breathe/notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    load();
    return MaterialApp(
      title: 'breathe',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'breathe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
    initVibration();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: Notifications.onSelectNotification);
  }

  void initVibration() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      vibration = canVibrate;
    });
  }

  int tab = 0;

  IconData icon = fabBreatheIcon;

  Color iconBackgroundColor = Colors.transparent;

  final List<Widget> tabs = [
    Breathe(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    void button() {
      if ((tab == 0)) {
        tab = 1;
        icon = fabSettingsIcon;
      } else if (tab == 1) {
        tab = 0;
        icon = fabBreatheIcon;
      }
      setState(() {});
    }

    return Scaffold(
      body: tabs[tab],
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            button();
            hapticFeedback(hapticFeedbackType.tap);
          },
          elevation: 0,
          child: Icon(icon, color: iconColor),
          backgroundColor: iconBackgroundColor),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
