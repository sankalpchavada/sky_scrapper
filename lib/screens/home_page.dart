import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts.dart';
import 'package:weather_app/providers/connectivity_provider.dart';
import 'package:weather_app/providers/theme_provider.dart';
import 'package:weather_app/screens/change_location_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.cityName});

  String? cityName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherFactory WeatherDetails = WeatherFactory(OpenWeather_API_KEY);
  Weather? weather;
  TextEditingValue textEditingValue = TextEditingValue();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetWeather();

    Provider.of<ConnectivityProvider>(context, listen: false)
        .checkConnectivity();

    loadAnim();

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

  loadAnim() {
    String lottieJsonPath;
    if (weather?.weatherMain! == "Clouds") {
      lottieJsonPath = "assets/animations/clouds_anim.json";
    } else if (weather?.weatherMain! == "Drizzle") {
      lottieJsonPath = "assets/animations/drizzle_anim.json";
    } else if (weather?.weatherMain! == "Rain") {
      lottieJsonPath = "assets/animations/rain_anim.json";
    } else if (weather?.weatherMain! == "Snow") {
      lottieJsonPath = "assets/animations/snow_anim.json";
    } else if (weather?.weatherMain! == "Haze" ||
        weather?.weatherMain! == "Smoke") {
      lottieJsonPath = "assets/animations/haze_anim.json";
    } else if (weather?.weatherMain! == "Clear") {
      lottieJsonPath = "assets/animations/clear_anim.json";
    } else {
      lottieJsonPath = "assets/animations/else_anim.json";
    }
    return lottieJsonPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (Provider.of<ConnectivityProvider>(context, listen: false)
                  .connectivityModel
                  .connectivityStatus ==
              'Offline')
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.blue),
                SizedBox(
                  height: 15,
                ),
                Text("waiting for network..")
              ],
            ))
          : Stack(
              children: [
                Container(
                  height: double.infinity,
                  child: Image.asset(
                    Provider.of<ThemeProvider>(context).themeDetails.isDark
                        ? "assets/images/_uhdminimal580.jpg"
                        : "assets/images/_uhdnature945.jpg",
                    fit: BoxFit.fitHeight,
                  ),
                ),
                SafeArea(child: WeatherUI())
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white12,
        elevation: 10,
        child: Center(
          child: Provider.of<ThemeProvider>(context).themeDetails.isDark
              ? const Icon(Icons.brightness_4_outlined)
              : const Icon(Icons.dark_mode, color: Colors.white),
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
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
        Expanded(child: weatherInfo()),
      ],
    );
  }

  Widget weatherInfo() {
    return GlassContainer.frostedGlass(
      height: 310,
      width: double.maxFinite,
      color: Colors.transparent,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 120,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Weather Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        weatherInfoContainer(
                            "${weather?.sunrise!.hour}:${weather?.sunrise!.minute} AM ",
                            "https://pics.freeicons.io/uploads/icons/png/6901965701667480211-512.png",
                            "Sunrise"),
                        weatherInfoContainer(
                            "${weather?.sunset!.hour}:${weather?.sunset!.minute}  ",
                            "https://pics.freeicons.io/uploads/icons/png/9473077081639145638-512.png",
                            "     Sunset\n(24hr Format)"),
                        weatherInfoContainer(
                            "${weather?.latitude!.toStringAsFixed(0)}°/${weather?.longitude!.toStringAsFixed(0)}°",
                            "https://pics.freeicons.io/uploads/icons/png/8992215681639496006-512.png",
                            "Latitude/Longitude"),
                        weatherInfoContainer(
                            weather?.humidity,
                            "https://pics.freeicons.io/uploads/icons/png/15648181211666941917-512.png",
                            "Humidity"),
                        weatherInfoContainer(
                            weather?.cloudiness,
                            "https://pics.freeicons.io/uploads/icons/png/14957074701678800765-512.png",
                            "Cloudiness"),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Temprature Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      weatherInfoContainer(
                          weather?.tempFeelsLike!.celsius!.toStringAsFixed(0),
                          "https://pics.freeicons.io/uploads/icons/png/21374267471600621651-512.png",
                          "feels Like"),
                      weatherInfoContainer(
                          weather?.tempMax!.celsius?.toStringAsFixed(0),
                          "https://pics.freeicons.io/uploads/icons/png/2539737811579547661-512.png",
                          "Maximum"),
                      weatherInfoContainer(
                          weather?.tempMin!.celsius!.toStringAsFixed(0),
                          "https://pics.freeicons.io/uploads/icons/png/5899223101679848580-512.png",
                          "Minimum")
                    ]),
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Wind Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        weatherInfoContainer(
                            weather?.pressure,
                            "https://pics.freeicons.io/uploads/icons/png/12606082331670650318-512.png",
                            "Pressure"),
                        weatherInfoContainer(
                            weather?.windDegree,
                            "https://pics.freeicons.io/uploads/icons/png/10425773121600621643-512.png",
                            "WindDegree"),
                        weatherInfoContainer(
                            weather?.windSpeed,
                            "https://pics.freeicons.io/uploads/icons/png/1901478181579547664-512.png",
                            "WindSpeed"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LAutocomplete(),
                ));
          },
          child: Text(
            "${weather?.areaName ?? ""},${weather?.country} ",
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
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
          DateFormat("h:mm a").format(now),
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
    return GlassContainer.clearGlass(
      height: 220,
      width: 220,
      elevation: 2,
      color: Colors.transparent,
      borderWidth: 0.1,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 150,
            width: 150,

            child: Lottie.asset("${loadAnim()}"),
            // decoration: BoxDecoration(
            //     color: Colors.black,
            //     image: DecorationImage(
            //         image: NetworkImage(
            //       "https://openweathermap.org/img/wn/${weather?.weatherIcon}.png",
            //     ))),
          ),
          Text(
            weather?.weatherMain ?? "",
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          ),
          Text(
            weather?.weatherDescription ?? "",
            style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget weatherTemp() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics:
          BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
      child: Row(
        children: [
          SizedBox(
            height: 100,
            width: MediaQuery.sizeOf(context).width,
            child: Center(
              child: Text(
                "${weather?.temperature!.celsius!.toStringAsFixed(0)}°C" ?? "",
                style: const TextStyle(fontSize: 50),
              ),
            ),
          ),
          SizedBox(
            height: 100,
            width: MediaQuery.sizeOf(context).width,
            child: Center(
              child: Text(
                "${weather?.temperature!.fahrenheit!.toStringAsFixed(0)}°F" ??
                    "",
                style: const TextStyle(fontSize: 50),
              ),
            ),
          ),
          SizedBox(
            height: 100,
            width: MediaQuery.sizeOf(context).width,
            child: Center(
              child: Text(
                "${weather?.temperature!.kelvin!.toStringAsFixed(0)}°K" ?? "",
                style: const TextStyle(fontSize: 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget weatherInfoContainer(var value, String IconImage, String wname) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GlassContainer.clearGlass(
        height: 120,
        width: 120,
        color: Colors.white38,
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 55, width: 55, child: Image.network("$IconImage")),
            Text("${value}"),
            Text(wname,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300)),
          ]),
        ),
      ),
    );
  }
}
