import 'package:flutter_web3/flutter_web3.dart';

class MetaMaskProvider {
  static const operatingChain = 1;

  String currentAddress = '';

  int currentChain = -1;

  bool _isEnabled = false;

  bool get isEnabled => _isEnabled;

  bool get isInOperatingChain => currentChain == operatingChain;

  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  Future<void> connect() async {
    if (_isEnabled) {
      final accs = await ethereum!.requestAccount();
      if (accs.isNotEmpty) currentAddress = accs.first;

      currentChain = await ethereum!.getChainId();
    }
  }

  clear() {
    currentAddress = '';
    currentChain = -1;
  }

  init() {
   dynamic  isAvailable = ethereum!.isConnected(); 
      _isEnabled = isAvailable;
    

    ethereum!.onAccountsChanged((accounts) {
      clear();
    });
    ethereum!.onChainChanged((accounts) {
      clear();
    });
  }
}
