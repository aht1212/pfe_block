import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:pfe_block/model/agent_model.dart';
import 'package:pfe_block/model/contribuable_model.dart';
import 'package:pfe_block/model/patente_model.dart';
import 'package:pfe_block/pages/agent/contribuableListPage.dart';
import 'package:pfe_block/services/tax_management_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web3dart/web3dart.dart';

class ContribuableSelectedPage extends StatefulWidget {
  final int contribuableId;
  const ContribuableSelectedPage({super.key, required this.contribuableId});

  @override
  State<ContribuableSelectedPage> createState() =>
      _ContribuableSelectedPageState();
}

String? addressAgent;

class _ContribuableSelectedPageState extends State<ContribuableSelectedPage> {
  PatenteManagement _patenteManagement = PatenteManagement();
  Contribuable? _contribuable;
  Future<Contribuable?> getContribuable(int idContribuable) async {
    _contribuable = await _patenteManagement.getContribuable(idContribuable);
    _patentesPayer = await _patenteManagement
        .getPatentesByContribuable(_contribuable!.ethAddress);
    List<Agent> agents = await _patenteManagement.getAgentAjouteEvents();

    addressAgent = await getUserEthAddress();
    // contribuableAdress = _contribuable!.ethAddress;
    return _contribuable!;
  }

// EthereumAddress? contribuableAdress;
  late Future<Contribuable?> getContribuableInfo;
  List<Patente> _patentesPayer = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getContribuableInfo = getContribuable(widget.contribuableId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Recouvrement"),
              bottom: const TabBar(tabs: [
                Tab(
                  text: "Recouvrer",
                  icon: Icon(Icons.perm_contact_calendar_rounded),
                ),
                Tab(
                  text: "Historique",
                  icon: Icon(Icons.work_history_outlined),
                ),
              ]),
            ),
            body: FutureBuilder(
                future: getContribuableInfo,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    _contribuable = snapshot.data;
                    return TabBarView(children: [
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // SizedBox(height: 100),

                                Expanded(
                                    child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      title: Text(
                                        _contribuable!.denomination,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                          "${_contribuable!.prenom + " " + _contribuable!.nom}"),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Divider(),
                                            ListTile(
                                              leading: Icon(Icons.phone),
                                              trailing: Text(_contribuable!
                                                  .contact
                                                  .toString()),
                                              title:
                                                  Text("Numéro de téléphone"),
                                            ),
                                            Divider(),
                                            ListTile(
                                              leading: Icon(Icons.email),
                                              trailing: Text(_contribuable!
                                                  .email
                                                  .toString()),
                                              title: Text("Adresse e-mail"),
                                            ),
                                            Divider(),
                                            ListTile(
                                              leading: Icon(Icons.location_on),
                                              trailing: Text(_contribuable!
                                                  .adresse
                                                  .toString()),
                                              title: Text("Adresse"),
                                            ),
                                            Divider(),
                                            ListTile(
                                              leading: Icon(Icons.date_range),
                                              trailing: Text(_contribuable!
                                                  .dateCreation
                                                  .toString()),
                                              title: Text("Date de creation"),
                                            ),
                                            Divider(),
                                            ListTile(
                                              leading: Icon(Icons.work),
                                              trailing: Text(_contribuable!
                                                  .typeContribuable
                                                  .toString()),
                                              title:
                                                  Text("Type de contribuable"),
                                            ),
                                            Divider(),
                                            ListTile(
                                              leading: Icon(Icons.person),
                                              trailing: Text(_contribuable!
                                                  .nombreEmployes
                                                  .toString()),
                                              title: Text("Nombre d'employés"),
                                            ),
                                            Divider(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    _patentesPayer.isEmpty ||
                                            !(_patentesPayer.any((element) =>
                                                element.anneePaiement ==
                                                DateTime.now().year))
                                        ? Center(
                                            child: GradientButtonFb4(
                                              text: "Recouvrer",
                                              onPressed: () async {
                                                int nextPatenteId = 0;
                                                await _patenteManagement
                                                    .ajouterPatente(
                                                        _contribuable!.id!,
                                                        DateTime.now().year,
                                                        EthereumAddress.fromHex(
                                                            addressAgent!));
                                                setState(() {
                                                  getContribuableInfo =
                                                      getContribuable(widget
                                                          .contribuableId);
                                                });

                                                List<Patente> nextPatentes =
                                                    await _patenteManagement
                                                        .getPatentesByContribuable(
                                                            _contribuable!
                                                                .ethAddress);

                                                nextPatenteId =
                                                    nextPatentes.last.id;
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                Center(
                                                                  child:
                                                                      ListTile(
                                                                    titleAlignment:
                                                                        ListTileTitleAlignment
                                                                            .center,
                                                                    title: Text(
                                                                      "Code Qr de validation de la transaction",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Divider(),
                                                                QrImageView(
                                                                  data:
                                                                      '${nextPatenteId}',
                                                                  version:
                                                                      QrVersions
                                                                          .auto,
                                                                  size: 320,
                                                                  gapless:
                                                                      false,
                                                                ),
                                                                Divider(),
                                                                Text(
                                                                    "Faites scanner le code qr par le contribuable svp")
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                            ),
                                          )
                                        : Container()
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ContribuableRecouvrementHistoric(
                        contribuable: _contribuable!,
                      )
                    ]);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                })));
  }
}

class GradientButtonFb4 extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const GradientButtonFb4(
      {required this.text, required this.onPressed, Key? key})
      : super(key: key);

  final double borderRadius = 25;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 33, 70, 181),
              Color.fromARGB(204, 33, 70, 181)
            ])),
        child: ElevatedButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                alignment: Alignment.center,
                padding: MaterialStateProperty.all(const EdgeInsets.only(
                    right: 75, left: 75, top: 15, bottom: 15)),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius)),
                )),
            onPressed: onPressed,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            )));
  }
}

class ContribuableRecouvrementHistoric extends StatefulWidget {
  final Contribuable contribuable;
  const ContribuableRecouvrementHistoric(
      {super.key, required this.contribuable});

  @override
  State<ContribuableRecouvrementHistoric> createState() =>
      _ContribuableRecouvrementHistoricState();
}

class _ContribuableRecouvrementHistoricState
    extends State<ContribuableRecouvrementHistoric> {
  PatenteManagement _patenteManagement = PatenteManagement();
  List<Patente> patentes = [];
  Future<List<Patente>> getContribuablePatentes(
      Contribuable contribuable) async {
    patentes = await _patenteManagement
        .getPatentesByContribuable(contribuable.ethAddress);

    return patentes;
  }

  late Future<List<Patente>> _getPatenteFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPatenteFuture = getContribuablePatentes(widget.contribuable);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getPatenteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des patentes.'));
          } else if (snapshot.hasData && (snapshot.data!.isEmpty)) {
            return Center(child: Text('Aucune patente enregistré.'));
          } else {
            patentes = patentes
                .where((element) => element.anneePaiement != 0)
                .toList();
            if (patentes.length != 0) {
              return ListView.separated(
                  itemCount: patentes.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      trailing: patentes[index].estPayee
                          ? Column(
                              children: [
                                Icon(Icons.verified),
                                Text("Payer"),
                              ],
                            )
                          : Column(
                              children: [
                                Icon(Icons.verified_outlined),
                                Text("Non Payer"),
                              ],
                            ),
                      title: Text("Patentes N°${patentes[index].id}"),
                      subtitle: Text("${patentes[index].anneePaiement}"),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          child: Center(
                                            child: Text(
                                              "Patente de ${widget.contribuable.denomination} - ${patentes[index].anneePaiement}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                        patentes[index].estPayee
                                            ? Column(
                                                children: [
                                                  Text(
                                                    "Déjà payé",
                                                    style: TextStyle(
                                                        fontSize: Theme.of(
                                                                context)
                                                            .primaryTextTheme
                                                            .headlineLarge!
                                                            .fontSize),
                                                  ),
                                                  Icon(
                                                    Icons.verified,
                                                    size: 200,
                                                  ),
                                                ],
                                              )
                                            : QrImageView(
                                                data: '${patentes[index].id}',
                                                version: QrVersions.auto,
                                                size: 320,
                                                gapless: false,
                                              ),
                                        Divider(),
                                        Text(
                                            "Montant : ${patentes[index].droitFixe + patentes[index].droitProportionnel}"),
                                        Text(
                                            "Faites scanner le code qr par le contribuable svp")

                                        //  patentes[index].estPayee ? Container() : GradientButtonFb4(text: "", onPressed: onPressed)
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                    );
                  });
            } else {
              return Center(child: Text('Aucune patente enregistré.'));
            }
          }
        });
  }
}
