import 'package:carousel_slider/carousel_slider.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:pfe_block/pages/contribuable/selectPatentePage.dart';
import 'package:flutter/material.dart';

class PatentePage extends StatefulWidget {
  const PatentePage({super.key});

  @override
  State<PatentePage> createState() => _PatentePageState();
}

class _PatentePageState extends State<PatentePage> {
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Envoi d\'argent'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Montant à envoyer:'),
            TextField(
              decoration: InputDecoration(
                hintText: 'Entrer le montant',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            Text('Montant disponible: 158 277€'),
            SizedBox(height: 16.0),
            Text('Transfert vers:'),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(Icons.account_balance),
                    Text('Société Générale'),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Icon(Icons.account_balance),
                    Text('Crédit Agricole'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            FilledButton(
              onPressed: () {
                // Gérer la validation du paiement
              },
              child: Text('Valider le paiement'),
              // color: Colors.blue,
              // textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  CouponCard cupounCardGen(Color color, String datepayer, String nomPatente,
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
              nomPatente,
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
                            builder: (context) => SelectPatentePage(
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
