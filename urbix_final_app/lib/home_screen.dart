import 'package:flutter/material.dart';
import '/components/layout_provider.dart';
// refreshcontroller
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // what happens when you pull down
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 800));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: RefreshController(),
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return // create container with indentation on each side and a height of 100
              Container(
            margin: EdgeInsets.symmetric(
              horizontal: LayoutProvider(context).indentation,
              vertical: 10,
            ),
            height: 100,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: <Widget>[
                  // First child in the stack, the background image
                  Container(
                    decoration: BoxDecoration(
                      //darken the image
                      image: DecorationImage(
                        image: AssetImage(rewardList[index].background),
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            Colors.black54, BlendMode.darken),
                      ),
                      borderRadius: BorderRadius.circular(5),
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

                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      // add image as child
                      child: Image.asset(
                        rewardList[index].logo,
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
                      width: 200, // specify the width of the text section here
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        '${rewardList[index].brand} - ${rewardList[index].coupon}',
                        style: const TextStyle(
                          color: Colors.white, // text color
                          fontSize: 13,
                          fontFamily: 'Inter', // text size
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.02, // text weight
                        ),
                      ),
                    ),
                  ),
                  // Fourth child in the stack, small box at the right bottom
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 100, // specify the width of the small box here
                      height: 30, // specify the height of the small box here
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.6), // black color with 0.5 opacity
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Aligns children at the center
                        children: <Widget>[
                          // First child in the Row, the text
                          Text(
                            rewardList[index].coins.toString() +
                                "€", // replace with your text
                            style: const TextStyle(
                              // yellow
                              color: Color(0xFFE5C558), // text color
                              fontSize: 12, // text size
                              fontWeight: FontWeight.bold, // text weight
                            ),
                          ),
                          // // Second child in the Row, the SVG picture
                          // SvgPicture.asset(
                          //   'assets/images/coin.svg', // replace with your SVG image asset path
                          //   height: 20, // adjust size as needed
                          //   width: 10, // adjust size as needed
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Reward {
  final String brand;
  final String coupon;
  final int coins;
  final String logo;
  final String background;

  Reward({
    required this.brand,
    required this.coupon,
    required this.coins,
    required this.logo,
    required this.background,
  });
}

List<Reward> rewardList = [
  Reward(
    brand: 'Augustiner',
    coupon: '10',
    coins: 3,
    logo: 'assets/images/Augustiner.jpg',
    background: 'assets/images/Augustiner_Keller.png',
  ),
  Reward(
    brand: 'Tegernsee',
    coupon: '8',
    coins: 3,
    logo: 'assets/images/Tegernseebier.jpeg',
    background: 'assets/images/Tegernsee.jpg',
  ),
  Reward(
    brand: 'Spezi',
    coupon: '12',
    coins: 2,
    logo: 'assets/images/Spezi.png',
    background: 'assets/images/superdry_background.png',
  ),
  // create more rewards Yfood
  Reward(
    brand: 'Yfood',
    coupon: '7',
    coins: 5,
    logo: 'assets/images/Yfood.png',
    background: 'assets/images/Yfood_background.jpg',
  ),
  //
];
