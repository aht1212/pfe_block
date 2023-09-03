import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:pfe_block/auth_api.dart';
import 'package:pfe_block/pages/contribuable/commercePage.dart';
import 'package:pfe_block/pages/contribuable/profilePage.dart';
import 'package:flutter/material.dart';

import 'contribuable/newsPage.dart';

class ContribuableScreen extends StatefulWidget {
  @override
  ContribuableScreenState createState() => ContribuableScreenState();
}

class ContribuableScreenState extends State<ContribuableScreen> {
  var currentIndex = 0;
  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  signOut();
                },
                icon: Icon(Icons.logout_outlined))
          ],
          backgroundColor: Colors.cyan,
          title: Center(child: Text(listPageNames[_currentIndex]))),
      body: SizedBox.expand(
        child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: listOfPages),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController!.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              activeColor: Colors.cyan,
              title: Text(listPageNames[0]),
              icon: Icon(Icons.home)),
          BottomNavyBarItem(
              activeColor: Colors.cyan,
              title: Text(listPageNames[1]),
              icon: Icon(
                Icons.credit_card_outlined,
              )),
          BottomNavyBarItem(
              activeColor: Colors.cyan,
              title: Text(listPageNames[2]),
              icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  Stack Menu(Size size, List<Widget> pages, List<IconData> pageIcons,
      List<String> pagesNames) {
    return Stack(
      children: [
        pages.elementAt(currentIndex),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(10),
            height: size.width * .190,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.15),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
              borderRadius: BorderRadius.circular(50),
            ),
            child: ListView.builder(
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: size.width * .024),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  setState(
                    () {
                      currentIndex = index;
                    },
                  );
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 1500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      margin: EdgeInsets.only(
                        bottom: index == currentIndex ? 0 : size.width * .029,
                        right: size.width * .0422,
                        left: size.width * .0422,
                      ),
                      width: size.width * .128,
                      height: index == currentIndex ? size.width * .014 : 0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                      ),
                    ),
                    Icon(
                      pageIcons[index],
                      size: size.width * .076,
                      color: index == currentIndex
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black38,
                    ),
                    Text(
                      pagesNames[index],
                      style: TextStyle(
                          color: index == currentIndex
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black38),
                    ),
                    // SizedBox(height: size.width * .03),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.credit_card_outlined,
    Icons.person_rounded,
  ];
  List<String> listPageNames = ["Accueil", "Commerces", "Profil"];
  List<Widget> listOfPages = [NewsFeedPage(), CommercePage(), ProfilePage()];
}
