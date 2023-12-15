import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts.dart';
import 'package:weather_app/providers/connectivity_provider.dart';
import 'package:weather_app/providers/theme_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.cityName});

  String? cityName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherFactory WeatherDetails = WeatherFactory(OpenWeather_API_KEY);
  Weather? weather;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetWeather();
    Provider.of<ConnectivityProvider>(context, listen: false)
        .checkConnectivity();

    print(widget.cityName.toString());
  }

  GetWeather() {
    WeatherDetails.currentWeatherByCityName(widget.cityName.toString())
        .then((value) {
      setState(() {
        weather = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (Provider.of<ConnectivityProvider>(context, listen: false)
                  .connectivityModel
                  .connectivityStatus ==
              'Offline')
          ? const Text("You are Offline...")
          : SafeArea(child: SingleChildScrollView(child: WeatherUI())),
      floatingActionButton: FloatingActionButton(
        child: Center(
          child: Provider.of<ThemeProvider>(context).themeDetails.isDark
              ? const Icon(Icons.brightness_4_outlined)
              : const Icon(Icons.dark_mode),
        ),
        onPressed: () {
          Provider.of<ThemeProvider>(context, listen: false).Changetheme();
        },
      ),
    );
  }

  Widget WeatherUI() {
    if (weather == null) {
      const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(
      // width: MediaQuery.sizeOf(context).width,
      // height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          locationDetails(),
          const SizedBox(
            height: 30,
          ),
          dateTimeDetails(),
          const SizedBox(
            height: 10,
          ),
          weatherIcon(),
          const SizedBox(
            height: 30,
          ),
          weatherTemp(),
          const SizedBox(
            height: 20,
          ),
          weatherInfo()
        ],
      ),
    );
  }

  Widget locationDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          CupertinoIcons.location,
          size: 20,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          "${weather?.areaName ?? ""},${weather?.country} ",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget dateTimeDetails() {
    DateTime now = DateTime.now();
    print(now);

    return Column(
      children: [
        Text(
          DateFormat("h:mm:a").format(now),
          style: const TextStyle(fontSize: 35),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat.yMEd().format(now),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget weatherIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://openweathermap.org/img/wn/${weather?.weatherIcon}.png"))),
        ),
        Text(
          weather?.weatherDescription ?? "",
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
        ),
      ],
    );
  }

  Widget weatherTemp() {
    return Text(
      "${weather?.temperature!.celsius!.toStringAsFixed(0)} C" ?? "",
      style: const TextStyle(fontSize: 50),
    );
  }

  Widget weatherInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.lightBlue,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "MAX Temp: ${weather?.tempMax!.celsius?.toStringAsFixed(0)} c",
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                          "MIN Temp: ${weather?.tempMin!.celsius?.toStringAsFixed(0)} c",
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 60,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.lightBlue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Wind Speed: ${weather?.windSpeed} km/h",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.lightBlue,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Humidity: ${weather?.humidity} ",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
