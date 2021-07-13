import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SettingTab extends StatefulWidget {
  const SettingTab({Key? key}) : super(key: key);

  @override
  _SettingTabState createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  late DatabaseReference dbRef;
  @override
  void initState() {
    dbRef = FirebaseDatabase.instance.reference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 20,
        ),
        StreamBuilder<Event?>(
            stream: dbRef.child('auto_control').onValue,
            builder: (context, snapshot) {
              bool? value = snapshot.data?.snapshot.value;
              return CustomSwitchTile(
                title: 'Auto Control',
                value: value ?? false,
                onChanged: (val) async {
                  print(val);
                  await dbRef.child('auto_control').set(val);
                },
              );
            }),
        SizedBox(
          height: 15,
        ),
        /*  CustomSwitchTile(
              title: 'Auto Control',
            ),
            SizedBox(
              height: 15,
            ), */
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [],
            color: Colors.white,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
              ),
              Spacer(),
              Text(
                'Restore factory settings',
                textScaleFactor: 0.9,
                style: TextStyle(
                  fontSize: 15,
                  // color: Color(0xFF4E5075),
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [],
            color: Colors.white,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
              ),
              Spacer(),
              Text(
                'Restore factory settings',
                textScaleFactor: 0.9,
                style: TextStyle(
                  fontSize: 15,
                  // color: Color(0xFF4E5075),
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        StreamBuilder<Event?>(
            stream: dbRef.child('messages').onValue,
            builder: (context, snapshot) {
              var notification = snapshot.data?.snapshot.value.values.toList();
              if (snapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(color: Colors.white),
                  margin: EdgeInsets.all(15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: notification.length,
                    itemBuilder: (context, index) {
                      return NotificationItem(
                        index: index,
                        date: notification[index]['date'] ?? "",
                        messageLenght: notification.length,
                        message: notification[index]['text'],
                      );
                    },
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            })
      ],
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    Key? key,
    required this.index,
    required this.date,
    required this.message,
    required this.messageLenght,
  }) : super(key: key);

  final int index;
  final String date;
  final int messageLenght;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                date,
                textScaleFactor: 0.9,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.3),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Icon(
                Icons.more_horiz,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            message,
            textScaleFactor: 0.9,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
              // color: Color(0xFF4E5075),
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          index == messageLenght-1 ? SizedBox() : Divider()
        ],
      ),
    );
  }
}

class CustomSwitchTile extends StatelessWidget {
  const CustomSwitchTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15.0).copyWith(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Text(
            title,
            textScaleFactor: 0.9,
            style: TextStyle(
              fontSize: 15,
              // color: Color(0xFF4E5075),
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          Transform.scale(
            scale: 0.6,
            child: CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeColor: Color(0xFF55DEBF),
            ),
          ),
        ],
      ),
    );
  }
}
