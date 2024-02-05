import 'dart:async';

import 'package:stackwallet/utilities/enums/coin_enum.dart';

/// Store chain height subscriptions for each coin.
abstract class ElectrumxChainHeightService {
  static Map<Coin, StreamSubscription<dynamic>?> subscriptions = {};
  // Used to hold chain height subscriptions for each coin as in:
  // ElectrumxChainHeightService.subscriptions[cryptoCurrency.coin] = sub;
}
