import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

class SelectCommercePage extends StatefulWidget {
  const SelectCommercePage({
    super.key,
    required this.refCommerce,
  });
  final String refCommerce;
  @override
  State<SelectCommercePage> createState() => _SelectCommercePageState();
}

class _SelectCommercePageState extends State<SelectCommercePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextScroll(
        'Historique des paiements ~ Réf : ${widget.refCommerce}',
        mode: TextScrollMode.bouncing,
        delayBefore: Duration(milliseconds: 3000),
        pauseBetween: Duration(milliseconds: 2000),
        velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
      )),
    );
  }
}
