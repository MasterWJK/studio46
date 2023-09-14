import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({super.key});

  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = [];

  // global listener counter initialized with 4
  String listenerCounter = "4";

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
    await device.connect();
    print('Device connected');

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

      // update the global listener counter with the value
      listenerCounter = receivedString;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Devices"),
      ),
      body: ListView(
        children: devicesList.map((device) {
          return ListTile(
            title: Text(device.name),
            subtitle: Text(device.id.toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical:
                            5), // Adjust padding to make the button smaller
                  ),
                  child: const Text("Unlock"),
                  onPressed: () => _connectToDevice(device),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical:
                            5), // Adjust padding to make the button smaller
                  ),
                  child: const Text("Lock"),
                  onPressed: () => _disconnectFromDevice(device),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical:
                            5), // Adjust padding to make the button smaller
                  ),
                  onPressed: () => _readValue(device),
                  child: const Text("Lis"),
                ),
                const SizedBox(width: 8),
                // container where the global listener counter is displayed
                Container(
                  child: Text(listenerCounter),
                ),
              ],
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startScan,
        child: const Icon(Icons.search),
      ),
    );
  }
}
