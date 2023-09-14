import 'package:flutter/material.dart';

import 'components/layout_provider.dart';

import 'dart:async';

class MyRobot extends StatefulWidget {
  final int issueId;

  const MyRobot({super.key, required this.issueId});

  @override
  State<MyRobot> createState() => _MyRobotState();
}

class _MyRobotState extends State<MyRobot> {
  @override
  void initState() {
    super.initState();
    _startTimer();
    _startTimer2();
  }

  void _startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (secoundcounter > 0) {
            secoundcounter--;
          } else {
            timer.cancel();
          }
        });
      },
    );
  }

  void _startTimer2() {
    timer2 = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (anotherCounter > 0) {
            anotherCounter--;
          } else {
            timer.cancel();
          }
        });
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    timer2.cancel();
    super.dispose();
  }

  late Timer timer;
  late Timer timer2; // Timer for the new counter

  int secoundcounter = 42; // First counter
  int anotherCounter = 302; // 3 minutes and 2 seconds

  @override
  Widget build(BuildContext context) {
    // Inside the build method or any other appropriate place
    int minutes = anotherCounter ~/ 60;
    int seconds = anotherCounter % 60;
    return Scaffold(
      backgroundColor: Colors.transparent, //Colors.black.withOpacity(0.6),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFFBFBFB),
              ),
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Builder(builder: (context) {
                      return Column(
                        children:
                            // Add title "Ludwig I"
                            [
                                  const Text(
                                    "Ludwig I",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 0,
                                  ),
                                ] +
                                itemList.map((item) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal:
                                          LayoutProvider(context).indentation,
                                      vertical: 10,
                                    ),
                                    height: 100,
                                    child: SizedBox(
                                      child: Stack(
                                        children: <Widget>[
                                          // First child in the stack, the background image
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image:
                                                    AssetImage(item.background),
                                                fit: BoxFit.cover,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        Colors.black54,
                                                        BlendMode.darken),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          // Second child in the stack, the additional image
                                          Positioned(
                                            left: 20,
                                            top: 20,
                                            bottom: 20,
                                            child: Container(
                                              width: 80,
                                              padding: const EdgeInsets.all(10),
                                              decoration: const BoxDecoration(
                                                // add background color and a border
                                                color: Colors.white,

                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3)),
                                              ),
                                              // add image as child
                                              child: Image.asset(
                                                item.logo,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          // Third child in the stack, the text section
                                          Positioned(
                                            right: 40,
                                            top: 15,
                                            bottom: 40,
                                            child: Container(
                                              padding: EdgeInsets.all(12.0),
                                              width:
                                                  200, // specify the width of the text section here
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Text(
                                                '${item.amount}x ${item.brand}',
                                                style: const TextStyle(
                                                  color: Colors
                                                      .white, // text color
                                                  fontSize: 13,
                                                  fontFamily:
                                                      'Inter', // text size
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing:
                                                      -0.02, // text weight
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              width: 100,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "${item.price}€",
                                                    style: const TextStyle(
                                                      color: Color(0xFFE5C558),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                      );
                    }),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 45,
                      width: 334,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        //green that fits to the background
                        color: const Color(0xFF8a8aff),
                      ),
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            // Red location flag
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFF8aff8a),
                              size: 26,
                            ),
                            Text(
                              " in:$secoundcounter seconds",
                              style: const TextStyle(
                                color: Colors.black,
                                // semibold
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFFff8a8a),
                              size: 26,
                            ),
                            Text(
                              "$minutes min $seconds sec",
                              style: TextStyle(
                                color: Colors.black,
                                // semibold
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ), // End of Column
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Items {
  final String amount;
  final String brand;
  final int price;
  final String logo;
  final String background;

  Items({
    required this.amount,
    required this.brand,
    required this.price,
    required this.logo,
    required this.background,
  });
}

List<Items> itemList = [
  Items(
    amount: '10',
    brand: 'Augustiner',
    price: 3,
    logo: 'assets/images/Augustiner.jpg',
    background: 'assets/images/Augustiner_Keller.png',
  ),
  Items(
    amount: '8',
    brand: 'Tegernsee',
    price: 3,
    logo: 'assets/images/Tegernseebier.jpeg',
    background: 'assets/images/Tegernsee.jpg',
  ),
  Items(
    amount: '12',
    brand: 'Spezi',
    price: 2,
    logo: 'assets/images/Spezi.png',
    background: 'assets/images/superdry_background.png',
  ),
  // create more rewards Yfood
  Items(
    amount: '7',
    brand: 'Yfood',
    price: 5,
    logo: 'assets/images/Yfood.png',
    background: 'assets/images/Yfood_background.jpg',
  ),
  //
];
