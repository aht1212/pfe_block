import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pfe_block/services/metamask.dart';
import 'package:pfe_block/services/tax_management_service.dart';

import 'homePageTestMetamaskTest.dart';

void main() async {
  runApp(const MyApp());
  await PatenteManagement().setup();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final provider = MetaMaskProvider()..init();

    return MaterialApp(
      title: 'Flutter Demo',
      // This theme was made for FlexColorScheme version 6.1.1. Make sure
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
      home: 
          MyHomePage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.provider}) : super(key: key);

//   final MetaMaskProvider provider;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late final MetaMaskProvider _provider;

//   @override
//   void initState() {
//     super.initState();
//     _provider = widget.provider;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF181818),
//       body: Stack(
//         children: [
//           Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (_provider.isConnected && _provider.isInOperatingChain)
//                   const Text('Connected')
//                 else if (_provider.isConnected && !_provider.isInOperatingChain)
//                   Text(
//                       'Wrong chain. Please connect to ${MetaMaskProvider.operatingChain}')
//                 else if (_provider.isEnabled)
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text('Click the button...'),
//                       const SizedBox(height: 8),
//                       MaterialButton(
//                         onPressed: () => _provider.connect(),
//                         color: Colors.white,
//                         padding: const EdgeInsets.all(0),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Image.network(
//                               'https://i0.wp.com/kindalame.com/wp-content/uploads/2021/05/metamask-fox-wordmark-horizontal.png?fit=1549%2C480&ssl=1',
//                               width: 300,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   )
//                 else
//                   const Text('Please use a Web3 supported browser.'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MetaMaskProvider {
//   static const operatingChain = 1;

//   String currentAddress = '';

//   int currentChain = -1;

//   bool _isEnabled = false;

//   bool get isEnabled => _isEnabled;

//   bool get isInOperatingChain => currentChain == operatingChain;

//   bool get isConnected => isEnabled && currentAddress.isNotEmpty;

//   Future<void> connect() async {
//     if (_isEnabled) {
//       final accs = await ethereum!.requestAccount();
//       if (accs.isNotEmpty) currentAddress = accs.first;

//       currentChain = await ethereum!.getChainId();
//     }
//   }

//   clear() {
//     currentAddress = '';
//     currentChain = -1;
//   }

//   init() {
//     // ethereum!..then((isAvailable) {
//     //   _isEnabled = isAvailable;
//     // });

//     _isEnabled = ethereum!.isConnected();
//     ethereum!.onAccountsChanged((accounts) {
//       clear();
//     });
//     ethereum!.onChainChanged((accounts) {
//       clear();
//     });
//   }
// }
