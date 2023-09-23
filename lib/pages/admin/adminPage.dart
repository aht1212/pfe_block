import 'package:pfe_block/pages/admin/dashboard.dart';
import 'package:pfe_block/pages/admin/rapport.dart';
import 'package:pfe_block/pages/admin/recensementManagement.dart';
import 'package:pfe_block/pages/admin/recouvrementManagement.dart';
import 'package:pfe_block/pages/admin/taxeConfiguration.dart';
import 'package:pfe_block/pages/admin/userManagement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/menu_model.dart';
import 'responsive.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int selected = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  List<MenuModel> menu = [
    MenuModel(icon: 'assets/svg/home.svg', title: "Dashboard"),
    MenuModel(icon: 'assets/svg/profile.svg', title: "Agent"),
    MenuModel(icon: 'assets/svg/exercise.svg', title: "Taxe Configuration"),
    MenuModel(icon: 'assets/svg/setting.svg', title: "Recensement"),
    MenuModel(icon: 'assets/svg/history.svg', title: "Recouvrement"),
    MenuModel(icon: 'assets/svg/signout.svg', title: "Rapport"),
    // MenuModel(icon: 'assets/svg/signout.svg', title: "Signout"),
  ];
  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      DashboardScreen(
        scaffoldKey: _scaffoldKey,
      ),
      UsersManagementScreen(),
      TaxConfigurationScreen(),
      RecensementManagementScreen(),
      RecouvrementManagementScreen(),
      ReportsScreen(),
    ];
    return Scaffold(
        key: _scaffoldKey,
        drawer: !Responsive.isDesktop(context)
            ? SizedBox(width: 250, child: menuM(context))
            : null,
        // endDrawer: Responsive.isMobile(context)
        //     ? SizedBox(
        //         width: MediaQuery.of(context).size.width * 0.8,
        //         child: const Profile())
        //     : null,
        body: SafeArea(
          child: Row(
            children: [
              if (Responsive.isDesktop(context))
                Expanded(
                  flex: 2,
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: menuM(context)),
                ),
              Expanded(flex: 8, child: _screens.elementAt(selected)),
              // if (!Responsive.isMobile(context))
              //    Expanded(
              //     flex: 3,
              //     child: Profile(),
              //   ),
            ],
          ),
        ));
  }

  Container menuM(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
        // color: const Color(0xFF171821)
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: Responsive.isMobile(context) ? 40 : 80,
            ),
            for (var i = 0; i < menu.length; i++)
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                  color: selected == i
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selected = i;
                    });
                    _scaffoldKey.currentState!.closeDrawer();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 7),
                        child: SvgPicture.asset(
                          menu[i].icon,
                          color: selected == i ? Colors.black : Colors.grey,
                        ),
                      ),
                      Text(
                        menu[i].title,
                        style: TextStyle(
                            fontSize: 16,
                            color: selected == i ? Colors.black : Colors.grey,
                            fontWeight: selected == i
                                ? FontWeight.w600
                                : FontWeight.normal),
                      )
                    ],
                  ),
                ),
              ),
          ],
        )),
      ),
    );
  }

  void _onActionSelected(String action) {
    // Implémenter les actions supplémentaires ici en fonction du label sélectionné.
    print('Action sélectionnée: $action');
  }
}

// Créez les autres écrans pour chaque section de l'application.



