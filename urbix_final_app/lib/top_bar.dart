import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/find_devices_screen.dart';
import 'components/layout_provider.dart';

class TopBar extends StatefulWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  bool bluetoothPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FindDevicesScreen()), // Replace FindDevicesScreen with the actual screen you want to navigate to
                );
              },
              child: Container(
                height: 44, // Adjust the height according to your needs
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
            ),
            GestureDetector(
              onTap: () {
                // connects to device
                setState(() {
                  bluetoothPressed = !bluetoothPressed; // Toggle the state
                });
                // connects to device
              },
              child: bluetoothPressed
                  ? Container(
                      height: 44, // Adjust the height according to your needs
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        color: const Color(0xFF00FF00),
                      ),
                      child: const Icon(
                        Icons.bluetooth,
                        color: Colors.black,
                      ),
                    )
                  : Container(
                      height: 44, // Adjust the height according to your needs
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
              behavior: HitTestBehavior.translucent,
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
    );
  }
}
