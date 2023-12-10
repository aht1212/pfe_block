import 'dart:typed_data';

import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pfe_block/model/patente_model.dart';
import 'package:pfe_block/pages/agent/contribuableListPage.dart';
import 'package:pfe_block/pages/contribuable/selectPatentePage.dart';
import 'package:flutter/material.dart';
import 'package:pfe_block/services/tax_management_service.dart';
import 'package:web3dart/web3dart.dart';

class PatentePage extends StatefulWidget {
  const PatentePage({super.key});

  @override
  State<PatentePage> createState() => _PatentePageState();
}

class _PatentePageState extends State<PatentePage> {
  bool isScanCompleted = false;
  PatenteManagement _patenteManagement = PatenteManagement();

  // get montantAPayer => null;

  void closeScreen() {
    isScanCompleted = false;
  }

  int montAPayer = 0;
  int montantPayer = 0;
  List<Patente> _patenteEvent = [];
  List<Patente> _patentes = [];
  Future<List<Patente>> getPatenteImpaye() async {
    String? addressContribuable = await getUserEthAddress();

    _patentes = await _patenteManagement.getPatentesByContribuable(
        EthereumAddress.fromHex(addressContribuable!));

    _patenteEvent = await _patenteManagement.getPatentesEvents();

    for (var element in _patentes) {
      montantPayer = montantPayer + (element.sommePayee ?? 0);
      montAPayer = montAPayer + element.droitFixe + element.droitProportionnel;
    }

    return _patentes;
  }

  late Future<List<Patente>> getPatente;
  MobileScannerController _mobileScannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    getPatente = getPatenteImpaye();
  }

  int idSelectionPatente = 0;
  @override
  Widget build(BuildContext context) {
    int restAPayer = montAPayer - montantPayer;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Patentes'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.history))],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: getPatente,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Patente> _patenteNonPayer = _patentes
                    .where((element) =>
                        element.estPayee == false && element.anneePaiement != 0)
                    .toList();
                // return Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     // Expanded(
                //     //   child: MobileScanner(
                //     //     // fit: BoxFit.contain,

                //     //     onDetect: (capture) {
                //     //       final List<Barcode> barcodes = capture.barcodes;
                //     //       final Uint8List? image = capture.image;
                //     //       for (final barcode in barcodes) {
                //     //         print('Barcode found! ${barcode.rawValue}');
                //     //       }
                //     //     },
                //     //   ),
                //     // ),
                //     // Text('Paiement'),
                //     TextField(
                //       // enabled: !patente.estPayee && ,
                //       decoration: InputDecoration(
                //         hintText: 'Payer montant',
                //       ),
                //       keyboardType: TextInputType.number,
                //     ),
                //     SizedBox(height: 16.0),
                //     Text('Montant à Payer: 158 277€'),
                //     SizedBox(height: 16.0),
                //     Text('Transfert vers:'),
                //     SizedBox(height: 8.0),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: <Widget>[
                //         Column(
                //           children: <Widget>[
                //             Icon(Icons.account_balance),
                //             Text('Société Générale'),
                //           ],
                //         ),
                //         Column(
                //           children: <Widget>[
                //             Icon(Icons.account_balance),
                //             Text('Crédit Agricole'),
                //           ],
                //         ),
                //       ],
                //     ),
                //     SizedBox(height: 16.0),
                //     FilledButton(
                //       onPressed: () {
                //         // Gérer la validation du paiement
                //       },
                //       child: Text('Valider le paiement'),
                //       // color: Colors.blue,
                //       // textColor: Colors.white,
                //     ),
                //   ],
                // );
                return Column(
                  children: [
                    Expanded(
                      // flex: ,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: _patenteNonPayer.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Checkbox(
                                value: !_mobileScannerController.isStarting
                                    ? idSelectionPatente ==
                                            _patenteNonPayer[index].id
                                        ? true
                                        : false
                                    : false,
                                onChanged: (value) {
                                  // return value;
                                },
                              ),
                              selected: !_mobileScannerController.isStarting
                                  ? idSelectionPatente ==
                                          _patenteNonPayer[index].id
                                      ? true
                                      : false
                                  : false,
                              title: Text(
                                "Année : ${_patenteNonPayer[index].anneePaiement.toString()}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(("Droit Fixe : " +
                                        _patenteNonPayer[index]
                                            .droitFixe
                                            .toString())),
                                    Text(("Droit proportionnelle :" +
                                        _patenteNonPayer[index]
                                            .droitProportionnel
                                            .toString()))
                                  ]),
                              trailing: Text(((_patenteNonPayer[index]
                                              .droitFixe +
                                          _patenteNonPayer[index]
                                              .droitProportionnel) -
                                      (_patenteNonPayer[index].sommePayee ?? 0))
                                  .toString()),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),

                    Expanded(
                      flex: 2,
                      child: _patenteNonPayer.isEmpty || idSelectionPatente != 0
                          ? Icon(
                              Icons.verified_user_rounded,
                              size: 100,
                            )
                          : MobileScanner(
                              // fit: BoxFit.contain,
                              controller: _mobileScannerController,
                              onDetect: (capture) {
                                final List<Barcode> barcodes = capture.barcodes;
                                final Uint8List? image = capture.image;
                                String idSelect = "";
                                for (final barcode in barcodes) {
                                  idSelect = barcode.rawValue!;
                                  setState(() {
                                    idSelectionPatente = int.parse(idSelect);
                                    _mobileScannerController.stop();
                                  });
                                }
                              },
                            ),
                    ),
                    // Spacer(),
                    Divider(),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Montant A payer: ${montAPayer}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Montant Payer: ${montantPayer}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          // Text(
                          //   "Total: ${_getTotal()}",
                          //   style: TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          // CardForm(
                          //   onPaymentResult: (result) {
                          //     // Handle payment result
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    TextField(
                      // enabled: idSelectionPatente == 0 && _mobileScannerController.isStarting,
                      onChanged: (value) {
                        setState(() {
                          montantPayer = int.tryParse(value) ?? 0;
                        });
                      },
                      // onSubmitted: (value){
                      //   setState(() {

                      //   });
                      // },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Montant'),
                    ),
                    // Spacer(),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                                Theme.of(context).colorScheme.primary.value),
                            textStyle: const TextStyle(color: Colors.white),
                            foregroundColor: Colors.white),
                        onPressed: () async {
                          String? addressContribuable =
                              await getUserEthAddress();

                          // Récupérer toutes les instances de la patente sélectionnée
                          List<Patente> selectedPatentes = _patenteEvent
                              .where(
                                  (element) => idSelectionPatente == element.id)
                              .toList();

                          // Calculer le montant total déjà payé pour toutes les instances de cette patente
                          int totalAmountPaid = selectedPatentes
                              .map<int>((patente) => patente.sommePayee ?? 0)
                              .fold(0, (sum, amount) => sum + amount);

                          // Calculer le montant total dû pour une instance de cette patente
                          int totalAmountDue =
                              selectedPatentes.first.droitFixe +
                                  selectedPatentes.first.droitProportionnel;

                          // Calculer le montant restant à payer pour cette patente
                          int remainingAmountDue =
                              totalAmountDue - totalAmountPaid;

                          // Vérifier si le montant à payer est inférieur ou égal au montant restant dû
                          if (montantPayer <= remainingAmountDue) {
                            // Effectuer le paiement seulement si le montant à payer est correct
                            await _patenteManagement.payerPatente(
                                idSelectionPatente,
                                montantPayer,
                                EthereumAddress.fromHex(addressContribuable!));

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("Paiement validé avec succès !")));
                          } else {
                            // Afficher un message d'erreur si le montant à payer est incorrect
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Montant à payer supérieur au montant restant.")));
                          }

                          _mobileScannerController.start();
                        },
                        child: Text("Payer"),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
            }),
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


class HistoriqueContribuablePatente extends StatefulWidget {
  const HistoriqueContribuablePatente({super.key});

  @override
  State<HistoriqueContribuablePatente> createState() => _HistoriqueContribuablePatenteState();
}

class _HistoriqueContribuablePatenteState extends State<HistoriqueContribuablePatente> {
  @override
  Widget build(BuildContext context) {
 PatenteManagement _patenteManagement = PatenteManagement(); 
    List<Patente> _patentes = []; 
    Future<List<Patente>> _getAllContribuablePatentes() async { 
          String? addressContribuable = await getUserEthAddress();

 List<Patente> _patenteByID = await _patenteManagement.getPatentesByContribuable(
        EthereumAddress.fromHex(addressContribuable!));

    List<Patente> _allPatentesPayed = await _patenteManagement.getPatentesEvents();
       _patentes = _allPatentesPayed.where((element) => element.contribuableId == _patenteByID.first.contribuableId).toList(); 
    return _patentes; 
    }
    return Container();
  }
}