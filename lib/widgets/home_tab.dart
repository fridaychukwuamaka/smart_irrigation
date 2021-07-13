import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<DisplayCard> cards = [
    DisplayCard(
      title: 'Temperature',
      subtitle: '00:00:00',
      icon: Icon(
        Icons.hourglass_empty_rounded,
      ),
    ),
    DisplayCard(
      title: 'Humidity',
      subtitle: '0 m',
      icon: Icon(
        FeatherIcons.droplet,
        // color: Color(0xFF4E5075),
      ),
    ),
    DisplayCard(
      title: 'Inlet Pressure',
      subtitle: '0 m',
      icon: Icon(
        FeatherIcons.droplet,
      ),
    ),
    DisplayCard(
      title: 'Opening Pumps',
      subtitle: '0/14',
      icon: Icon(
        FeatherIcons.droplet,
      ),
    ),
  ];

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      addAutomaticKeepAlives: false,
      // padding: EdgeInsets.all(20),
      children: [
        /*  Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.black,
        ), */
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: StreamBuilder<Event?>(
              stream: dbRef.child('moisture_sensor').onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  double value =
                      snapshot.data?.snapshot.value['value'].toDouble();
                  return SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                          radiusFactor: 0.85,
                          showAxisLine: false,
                          ticksPosition: ElementsPosition.outside,
                          labelsPosition: ElementsPosition.outside,
                          interval: 10,
                          axisLabelStyle: GaugeTextStyle(fontSize: 12),
                          majorTickStyle: MajorTickStyle(
                            length: 0.15,
                            lengthUnit: GaugeSizeUnit.factor,
                            thickness: 1,
                          ),
                          minorTicksPerInterval: 4,
                          minorTickStyle: MinorTickStyle(
                            length: 0.04,
                            lengthUnit: GaugeSizeUnit.factor,
                            thickness: 1,
                          ),
                          pointers: <GaugePointer>[
                            RangePointer(
                                width: 10,
                                pointerOffset: 10,
                                value: value,
                                animationDuration: 1000,
                                gradient: const SweepGradient(colors: <Color>[
                                  Color(0xFF22AE8E),
                                  Color(0xFF55DEBF),
                                ], stops: <double>[
                                  0.25,
                                  0.75
                                ]),
                                animationType: AnimationType.easeInCirc,
                                enableAnimation: true,
                                color: const Color(0xFFF8B195))
                          ])
                    ],
                  );
                } else {
                  return SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                          radiusFactor: 0.85,
                          showAxisLine: false,
                          ticksPosition: ElementsPosition.outside,
                          labelsPosition: ElementsPosition.outside,
                          interval: 10,
                          axisLabelStyle: GaugeTextStyle(fontSize: 12),
                          majorTickStyle: MajorTickStyle(
                            length: 0.15,
                            lengthUnit: GaugeSizeUnit.factor,
                            thickness: 1,
                          ),
                          minorTicksPerInterval: 4,
                          minorTickStyle: MinorTickStyle(
                            length: 0.04,
                            lengthUnit: GaugeSizeUnit.factor,
                            thickness: 1,
                          ),
                          pointers: <GaugePointer>[
                            RangePointer(
                                width: 10,
                                pointerOffset: 10,
                                value: 0,
                                animationDuration: 1000,
                                gradient: const SweepGradient(colors: <Color>[
                                  Color(0xFF22AE8E),
                                  Color(0xFF55DEBF),
                                ], stops: <double>[
                                  0.25,
                                  0.75
                                ]),
                                animationType: AnimationType.easeInCirc,
                                enableAnimation: true,
                                color: const Color(0xFFF8B195))
                          ])
                    ],
                  );
                }
              }),
        ),
        StreamBuilder<Event?>(
            stream: dbRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final value = snapshot.data!.snapshot.value;
                return GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2,
                  crossAxisSpacing: 20,
                  padding: EdgeInsets.all(15).copyWith(top: 0),
                  children: [
                    InfoCard(
                      icon: Icon(FeatherIcons.thermometer),
                      title: 'Temperature',
                      subTitle: '${value['temperature']} F',
                    ),
                    InfoCard(
                      icon: Icon(FeatherIcons.cloud),
                      title: 'Humidity',
                      subTitle: '${value['humidity']}',
                    ),
                    InfoCard(
                      icon: Icon(FeatherIcons.cloudRain),
                      title: 'Rainfall',
                      subTitle: value['rain'] ? 'Yes' : 'No',
                    ),
                    InfoCard(
                      icon: Icon(FeatherIcons.droplet),
                      title: 'Reservoir',
                      subTitle: value['water_level'] ? 'Yes' : 'No',
                    ),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            }),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 100,
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    fontSize: 14,
                    // color: Color(0xFF4E5075),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Text(
                  subTitle,
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    fontSize: 17,
                    // color: Color(0xFF4E5075),
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayCard {
  const DisplayCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Widget icon;
}
