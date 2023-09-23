import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pfe_block/homePageTestMetamaskTest.dart';
import 'package:pfe_block/home_page.dart';
import 'package:pfe_block/signIn.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  defaultTargetPlatform == TargetPlatform.android
      ? await Firebase.initializeApp()
      : await Firebase.initializeApp(
          options: FirebaseOptions(
          apiKey: "AIzaSyDvgGeMZ2o4kw12jbEA7Tbi1O0U31lsbxQ",
          appId: "1:599530081826:web:e98aef2c40321d2e92047b",
          messagingSenderId: "599530081826",
          projectId: "pfee-33331",
        ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Auth Demo',
      home: LoginPage(),

      //  This theme was made for FlexColorScheme version 6.1.1. Make sure
// you use same or higher version, but still same major version. If
// you use a lower version, some properties may not be supported. In
// that case you can also remove them after copying the theme to your app.
      theme: FlexThemeData.light(
        scheme: FlexScheme.bigStone,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 9,
        tooltipsMatchBackground: true,
        subThemesData: const FlexSubThemesData(
          textButtonRadius: 28.0,
          elevatedButtonRadius: 30.0,
          outlinedButtonPressedBorderWidth: 1.5,
          toggleButtonsBorderWidth: 2.5,
          inputDecoratorRadius: 30.0,
          inputDecoratorBorderWidth: 1.0,
          inputDecoratorFocusedBorderWidth: 3.0,
          fabUseShape: true,
          fabAlwaysCircular: true,
          chipRadius: 25.0,
          cardRadius: 20.0,
          popupMenuRadius: 12.0,
          popupMenuOpacity: 0.99,
          tooltipRadius: 30,
          bottomNavigationBarElevation: 3.0,
          navigationBarIndicatorOpacity: 0.11,
          navigationRailIndicatorOpacity: 0.35,
          navigationRailOpacity: 0.86,
          navigationRailElevation: 3.0,
          navigationRailLabelType: NavigationRailLabelType.selected,
        ),
        keyColors: const FlexKeyColors(),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.bigStone,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 15,
        appBarElevation: 3.0,
        darkIsTrueBlack: true,
        tooltipsMatchBackground: true,
        subThemesData: const FlexSubThemesData(
          textButtonRadius: 28.0,
          elevatedButtonRadius: 30.0,
          outlinedButtonPressedBorderWidth: 1.5,
          toggleButtonsBorderWidth: 2.5,
          inputDecoratorRadius: 30.0,
          inputDecoratorBorderWidth: 1.0,
          inputDecoratorFocusedBorderWidth: 3.0,
          fabUseShape: true,
          fabAlwaysCircular: true,
          chipRadius: 25.0,
          cardRadius: 20.0,
          popupMenuRadius: 12.0,
          popupMenuOpacity: 0.99,
          tooltipRadius: 30,
          bottomNavigationBarElevation: 3.0,
          navigationBarIndicatorOpacity: 0.11,
          navigationRailIndicatorOpacity: 0.35,
          navigationRailOpacity: 0.86,
          navigationRailElevation: 3.0,
          navigationRailLabelType: NavigationRailLabelType.selected,
        ),
        keyColors: const FlexKeyColors(),
        tones: FlexTones.material(Brightness.dark)
            .onMainsUseBW()
            .onSurfacesUseBW(),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

      themeMode: ThemeMode.system,
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    // checkLoggedInUser();
  }

  Future<void> checkLoggedInUser() async {
    // Vérifier si l'utilisateur est déjà connecté
    if (FirebaseAuth.instance.currentUser != null) {
      final adresseEth = await getUserEthAddress();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return MyHomeRealPage(addressConnected: adresseEth!);
      }));
    }
  }

  Future<String?> getUserEthAddress() async {
     User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final usersRef = FirebaseFirestore.instance.collection('users');
      final querySnapshot =
          await usersRef.where("email", isEqualTo: currentUser.email).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['adresseEth'];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return FutureBuilder<String?>(
            future: getUserEthAddress(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return MyHomeRealPage(addressConnected: snapshot.data!);
              } else {
                return SignInPage2();
              }
            },
          );
        } else {
          return SignInPage2();
        }
      },
    );
  }
}
