import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/services/event_bus/events/global/tor_connection_status_changed_event.dart';
import 'package:stackwallet/services/event_bus/global_event_bus.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:tor_ffi_plugin/tor_ffi_plugin.dart';

final pTorService = Provider((_) => TorService.sharedInstance);

class TorService {
  Tor? _tor;

  /// Flag to indicate that a Tor circuit is thought to have been established.
  bool _enabled = false;

  /// Getter for the enabled flag.
  bool get enabled => _enabled;

  TorService._();

  /// Singleton instance of the TorService.
  ///
  /// Use this to access the TorService and its properties.
  static final sharedInstance = TorService._();

  /// Getter for the proxyInfo.
  ///
  /// Returns a Map with the host and port of the Tor proxy.
  ({
    InternetAddress host,
    int port,
  }) get proxyInfo => (
        host: InternetAddress.loopbackIPv4,
        port: _tor!.port,
      );

  /// Initialize the tor ffi lib instance if it hasn't already been set. Nothing
  /// changes if _tor is already been set.
  void init({Tor? mockableOverride}) {
    _tor ??= mockableOverride ?? Tor.instance;
  }

  /// Start the Tor service.
  ///
  /// This will start the Tor service and establish a Tor circuit.
  ///
  /// Throws an exception if the Tor service fails to start.
  ///
  /// Returns a Future that completes when the Tor service has started.
  Future<void> start() async {
    if (_tor == null) {
      throw Exception("TorService.init has not been called!");
    }

    if (_enabled) {
      // already started so just return
      // could throw an exception here or something so the caller
      // is explicitly made aware of this
      // TODO restart tor after that's been added to the tor-ffi crate
      // (probably better to have a restart function separately)

      // Fire a TorConnectionStatusChangedEvent on the event bus.
      GlobalEventBus.instance.fire(
        TorConnectionStatusChangedEvent(
          TorConnectionStatus.connected,
          "Tor connection status changed: connect ($_enabled)",
        ),
      );
      return;
    }

    // Start the Tor service.
    try {
      GlobalEventBus.instance.fire(
        TorConnectionStatusChangedEvent(
          TorConnectionStatus.connecting,
          "Tor connection status changed: connecting",
        ),
      );
      await _tor!.start();
      // no exception or error so we can (probably?) assume tor
      // has started successfully
      _enabled = true;

      // Fire a TorConnectionStatusChangedEvent on the event bus.
      GlobalEventBus.instance.fire(
        TorConnectionStatusChangedEvent(
          TorConnectionStatus.connected,
          "Tor connection status changed: connect ($_enabled)",
        ),
      );
    } catch (e, s) {
      Logging.instance.log(
        "TorService.start failed: $e\n$s",
        level: LogLevel.Warning,
      );
      // _enabled should already be false

      // Fire a TorConnectionStatusChangedEvent on the event bus.
      GlobalEventBus.instance.fire(
        TorConnectionStatusChangedEvent(
          TorConnectionStatus.disconnected,
          "Tor connection status changed: $_enabled (failed)",
        ),
      );
      rethrow;
    }
  }

  Future<void> stop() async {
    if (_tor == null) {
      throw Exception("TorService.init has not been called!");
    }

    if (!_enabled) {
      // already stopped so just return
      // could throw an exception here or something so the caller
      // is explicitly made aware of this
      // TODO make sure to kill
      return;
    }

    // Stop the Tor service.
    try {
      _tor!.disable();
      // no exception or error so we can (probably?) assume tor
      // has started successfully
      _enabled = false;
      GlobalEventBus.instance.fire(
        TorConnectionStatusChangedEvent(
          TorConnectionStatus.disconnected,
          "Tor connection status changed: $_enabled (disabled)",
        ),
      );
    } catch (e, s) {
      Logging.instance.log(
        "TorService.stop failed: $e\n$s",
        level: LogLevel.Warning,
      );
      rethrow;
    }
  }
}
