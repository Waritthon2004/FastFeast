import 'dart:developer';

import 'package:fast_feast/widget/RegisRider.dart';
import 'package:fast_feast/widget/RegisUser.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<bool> isSelected = [true, false]; // For User and Rider toggle buttons
  Widget widgetField = const RegisUser();

  @override
  bool isUserSelected = true; // By default, 'User' is selected
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligns content to the left
                  children: [
                    const Text(
                      'Let\'s Create Your Account',
                      style:
                          TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    const Text('Select Account Type'),
                    Row(
                      children: [
                        isUserSelected
                            ? ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isUserSelected =
                                        true; // Mark 'User' as selected
                                    widgetField = const RegisUser();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.lightBlue, // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        18.0), // Rounded corners
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 30.0), // Button size
                                ),
                                child: const Text(
                                  'User',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    isUserSelected =
                                        true; // Mark 'User' as selected
                                    widgetField = const RegisUser();
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        18.0), // Rounded corners
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 30.0), // Button size
                                  side: BorderSide(
                                      color:
                                          Colors.grey.shade300), // Border color
                                ),
                                child: const Text(
                                  'User',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                        const SizedBox(width: 15),
                        !isUserSelected
                            ? ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isUserSelected =
                                        false; // Mark 'Rider' as selected
                                    widgetField = const RegisRider();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.lightBlue, // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        18.0), // Rounded corners
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 30.0), // Button size
                                ),
                                child: const Text(
                                  'Rider',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    isUserSelected =
                                        false; // Mark 'Rider' as selected
                                    widgetField = const RegisRider();
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        18.0), // Rounded corners
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 30.0), // Button size
                                  side: BorderSide(
                                      color:
                                          Colors.grey.shade300), // Border color
                                ),
                                child: const Text(
                                  'Rider',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ],
                    )
                  ],
                ),
      
                const SizedBox(height: 16.0),
                // Input Fields
                widgetField,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
