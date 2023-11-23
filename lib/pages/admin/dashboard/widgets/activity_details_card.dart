import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../model/health_model.dart'; // Assurez-vous d'importer correctement votre modèle HealthModel
import '../../responsive.dart';
import 'custom_card.dart';

class ActivityDetailsCard extends StatelessWidget {
  const ActivityDetailsCard({Key? key});

  final List<HealthModel> healthDetails = const [
    HealthModel(
      icon: 'assets/svg/business_icon.svg',
      value: "42", // Exemple : Nombre total d'agents
      title: "Total Agents",
    ),
    HealthModel(
      icon: 'assets/svg/taxpayer_icon.svg',
      value: "2 056", // Exemple : Nombre total de contribuables
      title: "Total Contribuables",
    ),
    HealthModel(
      icon: 'assets/svg/revenue_icon.svg',
      value: "1 003 450", // Exemple : Total des recettes collectées
      title: "Recettes Collectées",
    ),
    HealthModel(
      icon: 'assets/svg/market_icon.svg',
      value: "15", // Exemple : Nombre total de marchés
      title: "Total Marchés",
    ),
    HealthModel(
      icon: 'assets/svg/occupation_icon.svg',
      value: "20", // Exemple : Demandes d'occupation en attente
      title: "Occupations en Attente",
    ),
    // Ajoutez d'autres HealthModel selon vos besoins
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: healthDetails.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isMobile(context) ? 2 : 5,
        crossAxisSpacing: !Responsive.isMobile(context) ? 15 : 12,
        mainAxisSpacing: 12.0,
      ),
      itemBuilder: (context, i) {
        return AspectRatio(
          aspectRatio: 1.0, // Maintient un rapport d'aspect de 1:1
          child: CustomCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  healthDetails[i].icon,
                  fit: BoxFit.scaleDown,
                  width: 40,
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 4),
                  child: Text(
                    healthDetails[i].value,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  healthDetails[i].title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
