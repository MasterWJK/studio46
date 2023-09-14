import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urbix_final_app/components/find_devices_screen.dart';
import 'package:urbix_final_app/components/layout_provider.dart';

import 'map_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = [];

  int listenerCounter = 0;

  int left = 4;

  bool bluetoothPressed = false;

  bool isUnlocked = false; // Initialize the boolean variable
  bool isLoading = false; // Initialize the boolean variable

  bool bought = false;

  void toggleLock() async {
    setState(() {
      isLoading = true; // Set loading state to true
    });

    await Future.delayed(const Duration(seconds: 1), () {});
    setState(() {
      isUnlocked = !isUnlocked; // Toggle the lock state
      isLoading = false; //
    });
  }

  _startScan() async {
    devicesList.clear();
    flutterBlue.startScan(timeout: const Duration(seconds: 3));

    flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devicesList.contains(result.device.id)) {
          if (result.device.name == 'Adafruit Bluefruit LE') {
            setState(() {
              devicesList.add(result.device);
            });
            try {
              result.device.connect();
              print('Connected to ${result.device.name}');
              // Perform further operations with the device now that you're connected
            } catch (e) {
              print('Could not connect to ${result.device.name}: $e');
            }
          }
        }
      }
    });
    flutterBlue.stopScan();
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    // await device.connect();
    // print('Device connected');

    List<BluetoothService> services = await device.discoverServices();

    print('Device name: ${device.name}');
    // print('txCharacteristic: ${device.id}');

    String uartServiceStr = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
    String txCharateristicStr = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";

    // Find the correct service by its UUID
    BluetoothService uartService = services
        .firstWhere((service) => service.uuid.toString() == uartServiceStr);

    if (uartService == null) {
      print("UART Service not found.");
      return;
    }

    // Find the TX characteristic by its UUID
    BluetoothCharacteristic txCharacteristic = uartService.characteristics
        .firstWhere((characteristic) =>
            characteristic.uuid.toString() == txCharateristicStr);

    if (txCharacteristic == null) {
      print("TX Characteristic not found.");
      return;
    }

    String msg = 'U';

    await txCharacteristic.write(msg.codeUnits);
    print(msg + " Message sent");
    await Future.delayed(const Duration(seconds: 5), () {});
    String lock = "L";
    await txCharacteristic.write(lock.codeUnits);
    print(lock + " Message sent");

    // // disconnect
    // await device.disconnect();
    // print("disconnected");
  }

  // create a listener for RX characteristic
  Future<void> _readValue(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    print('Device name: ${device.name}');

    String uartServiceStr = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
    String rxCharateristicStr = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";

    // Find the correct service by its UUID
    BluetoothService uartService = services
        .firstWhere((service) => service.uuid.toString() == uartServiceStr);

    if (uartService == null) {
      print("UART Service not found.");
      return;
    }

    // Find the RX characteristic by its UUID
    BluetoothCharacteristic rxCharacteristic = uartService.characteristics
        .firstWhere((characteristic) =>
            characteristic.uuid.toString() == rxCharateristicStr);

    if (rxCharacteristic == null) {
      print("RX Characteristic not found.");

      return;
    }
    await rxCharacteristic.setNotifyValue(true);

    // Listen for notifications on the RX characteristic
    rxCharacteristic.value.listen((value) {
      if (value.isEmpty) {
        print('Received an empty value.');
        return;
      }
      print(value); // Should print the received byte array
      String receivedString = String.fromCharCodes(value);
      print('Received: $receivedString');

      // cast receivedString to int

      // update the global listener counter with the value
      listenerCounter = int.parse(receivedString);
    });
    setState(() {});
  }

  // send a L to disconnect same as the method above
  _disconnectFromDevice(BluetoothDevice device) async {
    // Asuming its is connected

    List<BluetoothService> services = await device.discoverServices();

    print('Device name: ${device.name}');
    // print('txCharacteristic: ${device.id}');

    String uartServiceStr = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
    String txCharateristicStr = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";

    // Find the correct service by its UUID
    BluetoothService uartService = services
        .firstWhere((service) => service.uuid.toString() == uartServiceStr);

    if (uartService == null) {
      print("UART Service not found.");
      return;
    }

    // Find the TX characteristic by its UUID
    BluetoothCharacteristic txCharacteristic = uartService.characteristics
        .firstWhere((characteristic) =>
            characteristic.uuid.toString() == txCharateristicStr);

    if (txCharacteristic == null) {
      print("TX Characteristic not found.");
      return;
    }

    String msg = 'L';

    await txCharacteristic.write(msg.codeUnits);
    print(msg + " Message sent");
    // disconnect
    await device.disconnect();
    print("disconnected");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // The 'body' property takes a 'Column' widget:
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: LayoutProvider(context).indentation,
                    vertical: LayoutProvider(context).topBarHeight * 0.46,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: LayoutProvider(context).topBarHeight,
                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: SvgPicture.asset(
                            'assets/LogoURbix.svg',
                            height: LayoutProvider(context).topBarHeight - 5.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Builder(builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FindDevicesScreen()), // Replace FindDevicesScreen with the actual screen you want to navigate to
                            );
                          },
                          child: Container(
                            height:
                                44, // Adjust the height according to your needs
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(27),
                              color: const Color(0xFFF3F3F3),
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }),
                      GestureDetector(
                        onTap: () {
                          // connects to device
                          setState(() {
                            bluetoothPressed =
                                !bluetoothPressed; // Toggle the state
                          });
                          // connects to device
                          _startScan();
                        },
                        child: bluetoothPressed
                            ? Container(
                                height:
                                    44, // Adjust the height according to your needs
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(27),
                                  color: const Color(0xFFFF8A40),
                                ),
                                child: const Icon(
                                  Icons.bluetooth,
                                  color: Colors.black,
                                ),
                              )
                            : Container(
                                height:
                                    44, // Adjust the height according to your needs
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(27),
                                  color: const Color(0xFFF3F3F3),
                                ),
                                child: const Icon(
                                  Icons.bluetooth,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // Goes to own profile
                        },
                        child: Container(
                          height: 44,
                          width: 44,
                          foregroundDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'assets/images/robot_profile.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 'Expanded' fills the remaining space in the column:
              Expanded(
                child: Stack(
                  children: [
                    // Shows the catelog in the robot
                    // const HomeScreen(),
                    Builder(builder: (context) {
                      return const MapScreen();
                    }),
                    // 'Positioned' widget is used to position the scan button on the screen:
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 40.0, left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    toggleLock();
                                    // _connectToDevice(device);
                                    // Loop through devices in devicesList and connect.
                                    for (var device in devicesList) {
                                      _connectToDevice(device);
                                    }
                                  });
                                },
                                child: Container(
                                  height: 54, // Sets the height of the button.
                                  width: 280, // Sets the width of the button.
                                  // padding: const EdgeInsets.symmetric(
                                  //   horizontal: 1,
                                  //   vertical: 1.0,
                                  // ), // Adds padding inside the button.
                                  decoration: BoxDecoration(
                                    // Provides styling for the button.
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            27.0)), // Makes the button round.
                                    gradient: LinearGradient(
                                      // Adds a gradient effect to the button's color.
                                      colors: isUnlocked
                                          ? [
                                              const Color(0xFF00FF00).withOpacity(
                                                  1.0), // Green when unlocked
                                              const Color(0xFF008000).withOpacity(
                                                  1.0), // Dark Green when unlocked
                                            ]
                                          : [
                                              const Color(0xEEFFA760)
                                                  .withOpacity(
                                                      1.0), // Original gradient
                                              const Color(0xFFFF8A40)
                                                  .withOpacity(
                                                      1.0), // Original gradient
                                            ],
                                      begin: const Alignment(-1.0, -2.0),
                                      end: const Alignment(1.0, 2.0),
                                    ),
                                    boxShadow: [
                                      // Adds a shadow effect to the button.
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    // Contains a row of widgets (icon and text).
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // Centers the row's children on the main axis.
                                    children: [
                                      isLoading
                                          ? const CircularProgressIndicator(
                                              // Display loading circle when isLoading is true
                                              strokeWidth: 3,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            )
                                          : Icon(
                                              isUnlocked
                                                  ? Icons.lock_open
                                                  : Icons
                                                      .lock, // Conditional icon based on lock state
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                      const SizedBox(
                                          width:
                                              10), // Provides a 10-pixel-wide space between the icon and the text.
                                      Text(
                                        isUnlocked ? "Buy" : "Unlock",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: -0.02,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  for (var device in devicesList) {
                                    _readValue(device);
                                  }
                                  setState(() {
                                    bought = !bought;
                                  });
                                },
                                child: bought
                                    ? Container(
                                        height:
                                            54, // Sets the height of the button.
                                        width:
                                            80, // Sets the width of the button.
                                        decoration: BoxDecoration(
                                          // Provides styling for the button.
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  27.0)), // Makes the button round.
                                          color: Color(0xFF00FF00),
                                          boxShadow: [
                                            // Adds a shadow effect to the button.
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text((left - listenerCounter)
                                                  .toString()),
                                              // Beer Icon
                                              const Icon(
                                                Icons.sports_bar,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height:
                                            54, // Sets the height of the button.
                                        width:
                                            80, // Sets the width of the button.
                                        decoration: BoxDecoration(
                                          // Provides styling for the button.
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  27.0)), // Makes the button round.
                                          color: const Color(0xFFF3F3F3),
                                          boxShadow: [
                                            // Adds a shadow effect to the button.
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text((left - listenerCounter)
                                                  .toString()),
                                              // Beer Icon
                                              const Icon(
                                                Icons.sports_bar,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
