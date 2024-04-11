import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../core/constants.dart';


class TodayInfo extends StatefulWidget {
  final Map weather;
  final String currentLocation;
  const TodayInfo({
    super.key,
    required this.weather, required this.currentLocation,
  });

  @override
  State<TodayInfo> createState() => _TodayInfoState();
}
class _TodayInfoState extends State<TodayInfo> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // final weather = Provider.of<WeatherProvider>(context).weather;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kcontentColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(20),
      child:
      Column(
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                "Today",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(DateTime.now()),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${widget.weather['main']['temp']}',
                      style: TextStyle(fontSize: width*.12),
                    ),
                    TextSpan(
                      text: "°C",
                      style: TextStyle(
                        fontSize: width*.08,
                        color: kprimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              /// check weather and showing climate image,
              widget.weather['main']['temp'] >=30?
              Image.asset("assets/sun-storm.png", width: 150,):
              widget.weather['main']['temp'] >=20?
              Image.asset("assets/cloud-sun.png", width: 150,):
              widget.weather['main']['temp'] <=20?
              Image.asset("assets/cloud-zap.png", width: 150,):
              widget.weather['main']['temp'] <=15?
              Image.asset("assets/cloud-rain.png", width: 150,):
              Image.asset("assets/cloud-zap.png", width: 100,)

            ],
          ),
           Row(
            children: [
              const Icon(Iconsax.location, color: kprimaryColor,),
               SizedBox(width: width*.02),
              // Text('${widget.weather['name']}',)
              widget.currentLocation.isEmpty? const Text('unknown location'):Text(widget.currentLocation)
            ],
          )
        ],
      ),
    );
  }
}
