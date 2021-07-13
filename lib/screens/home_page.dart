import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

import 'package:smart_irrigation/widgets/home_tab.dart';
import 'package:smart_irrigation/widgets/setting_tab.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late PageController _pageController = PageController(initialPage: 0);
  int _bottomNavIndex = 0;
  int selectedIndex = 1;
  String _appBarTitle = 'Monitor';
  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;

  late DatabaseReference dbRef;

  getToken() async {
    String fcmToken = (await _fcm.getToken(
        vapidKey:
            'BNnBGLQelyXAyzy6DEFB1sUGR-FIvi9cP_CN8Q5Q3INnGcS0Z4_2UArA6MBJ5BPPDnUGnOHoTaM-_1iB9FDN3V0'))!;
    print(fcmToken);
  }

  @override
  void initState() {
    super.initState();
    getToken();
    dbRef = FirebaseDatabase.instance.reference();

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(milliseconds: 850),
      () => _animationController.forward(),
    );

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;

      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              color: Color(0xFF55DEBF),
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;

      _pageController.animateToPage(1,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF55DEBF),
          title: Text(
            _appBarTitle,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        // backgroundColor: Color(0xFFf3f4f6),
        body: PageView(
          children: [
            HomeTab(),
            SettingTab(),
          ],
          onPageChanged: (index) {
            if (index == 0) {
              setState(() {
                _appBarTitle = 'Monitor';
                _bottomNavIndex = index;
              });
            } else {
              setState(() {
                _appBarTitle = 'Settings';
                _bottomNavIndex = index;
              });
            }
          },
          controller: _pageController,
        ),
        floatingActionButton: ScaleTransition(
          scale: animation,
          child: StreamBuilder<Event?>(
              stream: dbRef.child('pumpStatus').onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  bool pumpVal = snapshot.data?.snapshot.value;
                  return FloatingActionButton(
                    elevation: 8,
                    
                    backgroundColor:
                        pumpVal == true ? Color(0xFF55DEBF) : Colors.black,
                    child: Icon(
                      FeatherIcons.power,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _animationController.reset();
                      _animationController.forward();

                      dbRef.child('pumpStatus').set(!pumpVal);
                    },
                  );
                } else {
                  return FloatingActionButton(
                    elevation: 8,
                    backgroundColor: Colors.black,
                    child: Icon(
                      FeatherIcons.power,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _animationController.reset();
                      _animationController.forward();
                    },
                  );
                }
                ;
              }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: [
            FeatherIcons.home,
            FeatherIcons.settings,
          ],
          iconSize: 25,
          activeColor: Color(0xFF55DEBF),
          backgroundColor: Colors.white,

          height: 70,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.defaultEdge,
          leftCornerRadius: 30,
          rightCornerRadius: 30,
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
            if (index == 0) {
              setState(() {
                _appBarTitle = 'Monitor';
                _bottomNavIndex = index;
              });
            } else {
              setState(() {
                _appBarTitle = 'Settings';
                _bottomNavIndex = index;
              });
            }
          },
          //other params
        ),
      ),
    );
  }
}
