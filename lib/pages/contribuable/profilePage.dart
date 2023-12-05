import 'package:flutter/material.dart';
import 'package:pfe_block/model/contribuable_model.dart';
import 'package:pfe_block/pages/agent/contribuableListPage.dart';

import '../../services/tax_management_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  PatenteManagement _patenteManagement = PatenteManagement();
  Future<Contribuable?> getContribuable() async {
    Contribuable? contribuableSelected;

    List<Contribuable> contribuables =
        await _patenteManagement.getContribuableAjouteEvents();
    String? addressContribuable = await getUserEthAddress();
    for (Contribuable contribuable in contribuables) {
      if (contribuable.ethAddress.hexEip55 == addressContribuable) {
        contribuableSelected = contribuable;
      }
    }
    return contribuableSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getContribuable(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Contribuable _contribuable = snapshot.data!;
              return ListView(
                children: <Widget>[
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.lightBlueAccent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.5, 0.9],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 60.0,
                          // backgroundImage: NetworkImage(
                          //   'https://example.com/user_profile_image.jpg',
                          // ),
                          child: Icon(Icons.person),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${_contribuable.denomination}",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        Text(
                          "${_contribuable.prenom} ${_contribuable.nom}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${_contribuable.adresse}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ), // Text(
                        //   'Ville: Paris',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 20,
                        //   ),
                        // ),
                        // Text(
                        //   'Pays: France',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 20,
                        //   ),
                        // ),
                        Text(
                          '${_contribuable.contact}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${_contribuable.email}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Numéro d\'identification fiscale',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${_contribuable.nif}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Divider(),
                        // ListTile(
                        //   title: Text(
                        //     'Numéro d\'identification sociale',
                        //     style: TextStyle(
                        //       color: Colors.deepOrange,
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        //   subtitle: Text(
                        //     'ABCDEFGH',
                        //     style: TextStyle(
                        //       fontSize: 18,
                        //     ),
                        //   ),
                        // ),
                        // Divider(),
                        ListTile(
                          title: Text(
                            'Renseignements sur le compte ',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Type : ${_contribuable.typeContribuable} \nNombre d\'employé: ${_contribuable.nombreEmployes}\nValeur Locative: ${_contribuable.valeurLocative}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
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
    );
  }
}
