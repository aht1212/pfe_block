import 'package:flutter/material.dart';

import 'homePageTestMetamaskTest.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final provider = MetaMaskProvider()..init();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(),
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
