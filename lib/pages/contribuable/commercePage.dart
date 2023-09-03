import 'package:carousel_slider/carousel_slider.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:pfe_block/pages/contribuable/selectBoutiquePage.dart';
import 'package:flutter/material.dart';

class CommercePage extends StatefulWidget {
  const CommercePage({super.key});

  @override
  State<CommercePage> createState() => _CommercePageState();
}

class _CommercePageState extends State<CommercePage> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> images = [
      cupounCardGen(Colors.red, "30 jan 2023", "BOUTIQUE DE CHAUSSURES", "0",
          "898282727"),
      cupounCardGen(
          Colors.blue, "2023-07-17", "My Super Store", "5000", "8902928892"),
      cupounCardGen(
          Colors.green, "2023-07-20", "Best Electronics", "8000", "1099290929"),
      cupounCardGen(Colors.deepOrange, "2023-07-25", "Fashionista Boutique",
          "3000", "339939292")
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                  enableInfiniteScroll: false,
                  viewportFraction: 0.4,
                  // padEnds: false,
                  // height: MediaQuery.of(context).size.height * 0.7,
                  aspectRatio: 1,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.vertical,
                  // autoPlay: true,
                  enlargeFactor: 0.13),
              items: images,
            ),
          ),
        ],
      ),
    );
  }

  CouponCard cupounCardGen(Color color, String datepayer, String nomCommerce,
      String impayes, String numRef) {
    return CouponCard(
      height: 200,
      firstChild: Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Impayés',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.white54, height: 0),
            Expanded(
              child: Center(
                child: Text(
                  "${impayes} FCFA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      secondChild: Container(
        padding: EdgeInsets.all(5),
        width: double.maxFinite,
        color: color.withOpacity(0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                ),
                Text(
                  'Badalabougou - N° Réf : $numRef',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(225, 242, 235, 235),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              nomCommerce,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 73, 75, 75),
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectCommercePage(
                                  refCommerce: numRef,
                                )),
                      );
                    },
                    child: Text("Details"))),
            Spacer(),
            Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),
                Text(
                  'Date payement - $datepayer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 254, 254),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      curveAxis: Axis.vertical,
    );
  }
}
