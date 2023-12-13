import 'dart:typed_data';

import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pfe_block/model/patente_model.dart';
import 'package:pfe_block/pages/agent/contribuableListPage.dart';
import 'package:pfe_block/pages/contribuable/selectPatentePage.dart';
import 'package:flutter/material.dart';
import 'package:pfe_block/services/tax_management_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

    List<Patente> _patentesByContribuable =
        await _patenteManagement.getPatentesByContribuable(
            EthereumAddress.fromHex(addressContribuable!));
    _patentesByContribuable = _patentesByContribuable
        .where((element) => element.contribuableId != 0)
        .toList();
    _patenteEvent = await _patenteManagement.getPatentesEvents();
    for (int i = 0; i < _patentesByContribuable.length; i++) {
      List<Patente> patentePayedByContribuableByPatente = _patenteEvent
          .where((element) => element.id == _patentesByContribuable[i].id)
          .toList();
      int totalAmountPaid = patentePayedByContribuableByPatente.isEmpty
          ? 0
          : patentePayedByContribuableByPatente
              .map<int>((patente) => patente.sommePayee ?? 0)
              .fold(0, (sum, amount) => sum + amount);
      int montantDue = patentePayedByContribuableByPatente.first.droitFixe +
          patentePayedByContribuableByPatente.first.droitProportionnel;

      if (totalAmountPaid < montantDue) {
        _patentes.add(Patente(
            id: patentePayedByContribuableByPatente[i].id,
            contribuableId:
                patentePayedByContribuableByPatente[i].contribuableId,
            droitFixe: patentePayedByContribuableByPatente[i].droitFixe,
            droitProportionnel:
                patentePayedByContribuableByPatente[i].droitProportionnel,
            anneePaiement: patentePayedByContribuableByPatente[i].anneePaiement,
            estPayee: false,
            sommePayee: totalAmountPaid));
        montAPayer = montantDue;
        montantPayer = totalAmountPaid;
      }
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return HistoriqueContribuablePatente();
                }));
              },
              icon: Icon(Icons.history))
        ],
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
  State<HistoriqueContribuablePatente> createState() =>
      _HistoriqueContribuablePatenteState();
}

class _HistoriqueContribuablePatenteState
    extends State<HistoriqueContribuablePatente> {
  PatenteManagement _patenteManagement = PatenteManagement();
  List<Patente> _patentes = [];
  Future<List<Patente>> _getAllContribuablePatentes() async {
    String? addressContribuable = await getUserEthAddress();

    List<Patente> _patenteByID =
        await _patenteManagement.getPatentesByContribuable(
            EthereumAddress.fromHex(addressContribuable!));

    List<Patente> _allPatentesPayed =
        await _patenteManagement.getPatentesEvents();
    _patentes = _allPatentesPayed
        .where((element) =>
            element.contribuableId ==
            _patenteByID
                .where((element) => element.contribuableId != 0)
                .first
                .contribuableId)
        .toList();
    return _patentes;
  }

  late Future<List<Patente>> _getPatentesFuture;

  @override
  void initState() {
    super.initState();
    _getPatentesFuture = _getAllContribuablePatentes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historique des patentes"),
      ),
      body: FutureBuilder(
          future: _getPatentesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur de chargement des _patentes.'));
            } else if (snapshot.hasData && (snapshot.data!.isEmpty)) {
              return Center(child: Text('Aucune patente enregistré.'));
            } else {
              _patentes = _patentes
                  .where((element) => element.anneePaiement != 0)
                  .toList();
              if (_patentes.length != 0) {
                return ListView.separated(
                    itemCount: _patentes.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: Text(
                            _patentes[index].anneePaiement.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // trailing: _patentes[index].estPayee
                          //     ? Column(
                          //         children: [
                          //           Icon(Icons.verified),
                          //           Text("Payer"),
                          //         ],
                          //       )
                          //     : Column(
                          //         children: [
                          //           Icon(Icons.verified_outlined),
                          //           Text("Non Payer"),
                          //         ],
                          //       ),
                          title: Text("Patentes N°${_patentes[index].id}"),
                          subtitle: Text(
                              "Montant payé : ${_patentes[index].sommePayee ?? 0}"),
                          // onTap: () {
                          //   showModalBottomSheet(
                          //       context: context,
                          //       builder: (BuildContext context) {
                          //         return Row(
                          //           children: [
                          //             Expanded(
                          //               child: Column(
                          //                 children: [
                          //                   SizedBox(
                          //                     height: 20,
                          //                     child: Center(
                          //                       child: Text(
                          //                         "Patente ${_patentes[index].anneePaiement}",
                          //                         style: TextStyle(
                          //                             fontSize: 16,
                          //                             fontWeight:
                          //                                 FontWeight.bold),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   Divider(),
                          //                   _patentes[index].estPayee
                          //                       ? Column(
                          //                           children: [
                          //                             Text(
                          //                               "Déjà payé",
                          //                               style: TextStyle(
                          //                                   fontSize: Theme.of(
                          //                                           context)
                          //                                       .primaryTextTheme
                          //                                       .headlineLarge!
                          //                                       .fontSize),
                          //                             ),
                          //                             Icon(
                          //                               Icons.verified,
                          //                               size: 200,
                          //                             ),
                          //                           ],
                          //                         )
                          //                       : QrImageView(
                          //                           data:
                          //                               '${_patentes[index].id}',
                          //                           version: QrVersions.auto,
                          //                           size: 320,
                          //                           gapless: false,
                          //                         ),
                          //                   Divider(),
                          //                   Text(
                          //                       "Montant : ${_patentes[index].droitFixe + _patentes[index].droitProportionnel}"),
                          //                   Text(
                          //                       "Faites scanner le code qr par le contribuable svp")

                          //                   //  _patentes[index].estPayee ? Container() : GradientButtonFb4(text: "", onPressed: onPressed)
                          //                 ],
                          //               ),
                          //             ),
                          //           ],
                          //         );
                          //       });
                          // },
                        ),
                      );
                    });
              } else {
                return Center(child: Text('Aucune patente enregistré.'));
              }
            }
          }),
    );
  }
}
