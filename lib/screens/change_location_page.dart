import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/screens/home_page.dart';

import '../cityList.dart';
import '../providers/theme_provider.dart';

class LAutocomplete extends StatefulWidget {
  const LAutocomplete({super.key});

  @override
  State<LAutocomplete> createState() => _LAutocompleteState();
}

class _LAutocompleteState extends State<LAutocomplete> {
  TextEditingController textController = TextEditingController();
  String? SaveTHIS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.center,
                child: Text("Search & "
                    "Select Location")),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_outlined),
                    Container(
                      height: 50,
                      width: 250,
                      child: Autocomplete<String>(
                        displayStringForOption: (option) {
                          return option.toLowerCase();
                        },
                        optionsBuilder: (textController) {
                          if (textController.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return options.where((String option) {
                            return option
                                .contains(textController.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          SaveTHIS = selection;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HomePage(
                                  cityName: selection,
                                );
                              },
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(selection),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
