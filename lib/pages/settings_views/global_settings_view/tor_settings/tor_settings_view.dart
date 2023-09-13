/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stackwallet/providers/global/prefs_provider.dart';
import 'package:stackwallet/services/event_bus/events/global/tor_connection_status_changed_event.dart';
import 'package:stackwallet/services/event_bus/global_event_bus.dart';
import 'package:stackwallet/services/tor_service.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/conditional_parent.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/custom_buttons/draggable_switch_button.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';
import 'package:stackwallet/widgets/stack_dialog.dart';

class TorSettingsView extends ConsumerStatefulWidget {
  const TorSettingsView({Key? key}) : super(key: key);

  static const String routeName = "/torSettings";

  @override
  ConsumerState<TorSettingsView> createState() => _TorSettingsViewState();
}

class _TorSettingsViewState extends ConsumerState<TorSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor:
              Theme.of(context).extension<StackColors>()!.backgroundAppBar,
          leading: AppBarBackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Tor settings",
            style: STextStyles.navBarTitle(context),
          ),
          actions: [
            AspectRatio(
              aspectRatio: 1,
              child: AppBarIconButton(
                icon: SvgPicture.asset(
                  Assets.svg.circleQuestion,
                ),
                onPressed: () {
                  showDialog<dynamic>(
                    context: context,
                    useSafeArea: false,
                    barrierDismissible: true,
                    builder: (context) {
                      return const StackDialog(
                        title: "What is Tor?",
                        message:
                            "Short for \"The Onion Router\", is an open-source software that enables internet communication"
                            " to remain anonymous by routing internet traffic through a series of layered nodes,"
                            " to obscure the origin and destination of data.",
                        rightButton: SecondaryButton(
                          label: "Close",
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TorIcon(),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const TorButton(),
              const SizedBox(
                height: 8,
              ),
              RoundedWhiteContainer(
                child: Consumer(
                  builder: (_, ref, __) {
                    return RawMaterialButton(
                      // splashColor: Theme.of(context).extension<StackColors>()!.highlight,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Constants.size.circularBorderRadius,
                        ),
                      ),
                      onPressed: null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Tor killswitch",
                                  style: STextStyles.titleBold12(context),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    showDialog<dynamic>(
                                      context: context,
                                      useSafeArea: false,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return const StackDialog(
                                          title: "What is Tor killswitch?",
                                          message:
                                              "A security feature that protects your information from accidental exposure by"
                                              " disconnecting your device from the Tor network if your virtual private network (VPN)"
                                              " connection is disrupted or compromised.",
                                          rightButton: SecondaryButton(
                                            label: "Close",
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    Assets.svg.circleInfo,
                                    height: 16,
                                    width: 16,
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .infoItemLabel,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                              width: 40,
                              child: DraggableSwitchButton(
                                isOn: ref.watch(
                                  prefsChangeNotifierProvider
                                      .select((value) => value.torKillswitch),
                                ),
                                onValueChanged: (newValue) {
                                  ref
                                      .read(prefsChangeNotifierProvider)
                                      .torKillswitch = newValue;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TorIcon extends ConsumerStatefulWidget {
  const TorIcon({super.key});

  @override
  ConsumerState<TorIcon> createState() => _TorIconState();
}

class _TorIconState extends ConsumerState<TorIcon> {
  late TorConnectionStatus _status;

  Color _color(
    TorConnectionStatus status,
    StackColors colors,
  ) {
    switch (status) {
      case TorConnectionStatus.disconnected:
        return colors.textSubtitle3;

      case TorConnectionStatus.connected:
        return colors.accentColorGreen;

      case TorConnectionStatus.connecting:
        return colors.accentColorYellow;
    }
  }

  String _label(
    TorConnectionStatus status,
    StackColors colors,
  ) {
    switch (status) {
      case TorConnectionStatus.disconnected:
        return "CONNECT";

      case TorConnectionStatus.connected:
        return "STOP";

      case TorConnectionStatus.connecting:
        return "CONNECTING";
    }
  }

  bool _tapLock = false;

  Future<void> onTap() async {
    if (_tapLock) {
      return;
    }
    _tapLock = true;
    try {
      // Connect or disconnect when the user taps the status.
      switch (_status) {
        case TorConnectionStatus.disconnected:
          await _connectTor(ref, context);
          break;

        case TorConnectionStatus.connected:
          await _disconnectTor(ref, context);

          break;

        case TorConnectionStatus.connecting:
          // Do nothing.
          break;
      }
    } catch (_) {
      // any exceptions should already be handled with error dialogs
      // this try catch is just extra protection to ensure _tapLock gets reset
      // in the finally block in the event of an unknown error
    } finally {
      _tapLock = false;
    }
  }

  @override
  void initState() {
    _status = ref.read(pTorService).enabled
        ? TorConnectionStatus.connected
        : TorConnectionStatus.disconnected;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _TorSubscriptionBase(
      onTorStatusChanged: (status) {
        setState(() {
          _status = status;
        });
      },
      child: ConditionalParent(
        condition: _status != TorConnectionStatus.connecting,
        builder: (child) => GestureDetector(
          onTap: onTap,
          child: child,
        ),
        child: SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              SvgPicture.asset(
                Assets.svg.tor,
                color: _color(
                  _status,
                  Theme.of(context).extension<StackColors>()!,
                ),
                width: 200,
                height: 200,
              ),
              Text(
                _label(
                  _status,
                  Theme.of(context).extension<StackColors>()!,
                ),
                style: STextStyles.smallMed14(context).copyWith(
                  color: Theme.of(context).extension<StackColors>()!.popupBG,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TorButton extends ConsumerStatefulWidget {
  const TorButton({super.key});

  @override
  ConsumerState<TorButton> createState() => _TorButtonState();
}

class _TorButtonState extends ConsumerState<TorButton> {
  late TorConnectionStatus _status;

  Color _color(
    TorConnectionStatus status,
    StackColors colors,
  ) {
    switch (status) {
      case TorConnectionStatus.disconnected:
        return colors.textSubtitle3;

      case TorConnectionStatus.connected:
        return colors.accentColorGreen;

      case TorConnectionStatus.connecting:
        return colors.accentColorYellow;
    }
  }

  String _label(
    TorConnectionStatus status,
    StackColors colors,
  ) {
    switch (status) {
      case TorConnectionStatus.disconnected:
        return "Disconnected";

      case TorConnectionStatus.connected:
        return "Connected";

      case TorConnectionStatus.connecting:
        return "Connecting";
    }
  }

  bool _tapLock = false;

  Future<void> onTap() async {
    if (_tapLock) {
      return;
    }
    _tapLock = true;
    try {
      // Connect or disconnect when the user taps the status.
      switch (_status) {
        case TorConnectionStatus.disconnected:
          await _connectTor(ref, context);
          break;

        case TorConnectionStatus.connected:
          await _disconnectTor(ref, context);

          break;

        case TorConnectionStatus.connecting:
          // Do nothing.
          break;
      }
    } catch (_) {
      // any exceptions should already be handled with error dialogs
      // this try catch is just extra protection to ensure _tapLock gets reset
      // in the finally block in the event of an unknown error
    } finally {
      _tapLock = false;
    }
  }

  @override
  void initState() {
    _status = ref.read(pTorService).enabled
        ? TorConnectionStatus.connected
        : TorConnectionStatus.disconnected;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _TorSubscriptionBase(
      onTorStatusChanged: (status) {
        setState(() {
          _status = status;
        });
      },
      child: GestureDetector(
        onTap: onTap,
        child: RoundedWhiteContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text(
                  "Tor status",
                  style: STextStyles.titleBold12(context),
                ),
                const Spacer(),
                Text(
                  _label(
                    _status,
                    Theme.of(context).extension<StackColors>()!,
                  ),
                  style: STextStyles.itemSubtitle(context).copyWith(
                    color: _color(
                      _status,
                      Theme.of(context).extension<StackColors>()!,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TorSubscriptionBase extends ConsumerStatefulWidget {
  const _TorSubscriptionBase({
    super.key,
    required this.onTorStatusChanged,
    this.eventBus,
    required this.child,
  });

  final Widget child;
  final void Function(TorConnectionStatus) onTorStatusChanged;
  final EventBus? eventBus;

  @override
  ConsumerState<_TorSubscriptionBase> createState() =>
      _TorSubscriptionBaseState();
}

class _TorSubscriptionBaseState extends ConsumerState<_TorSubscriptionBase> {
  /// The global event bus.
  late final EventBus eventBus;

  /// Subscription to the TorConnectionStatusChangedEvent.
  late StreamSubscription<TorConnectionStatusChangedEvent>
      _torConnectionStatusSubscription;

  @override
  void initState() {
    // Initialize the global event bus.
    eventBus = widget.eventBus ?? GlobalEventBus.instance;

    // Subscribe to the TorConnectionStatusChangedEvent.
    _torConnectionStatusSubscription =
        eventBus.on<TorConnectionStatusChangedEvent>().listen(
      (event) async {
        widget.onTorStatusChanged.call(event.newStatus);
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the TorConnectionStatusChangedEvent subscription.
    _torConnectionStatusSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Connect to the Tor network.
///
/// This method is called when the user taps the "Connect" button.
///
/// Throws an exception if the Tor service fails to start.
///
/// Returns a Future that completes when the Tor service has started.
Future<void> _connectTor(WidgetRef ref, BuildContext context) async {
  // Init the Tor service if it hasn't already been.
  ref.read(pTorService).init();

  // Start the Tor service.
  try {
    await ref.read(pTorService).start();

    // Toggle the useTor preference on success.
    ref.read(prefsChangeNotifierProvider).useTor = true;
  } catch (e, s) {
    Logging.instance.log(
      "Error starting tor: $e\n$s",
      level: LogLevel.Error,
    );
    // TODO: show dialog with error message
  }

  return;
}

/// Disconnect from the Tor network.
///
/// This method is called when the user taps the "Disconnect" button.
///
/// Throws an exception if the Tor service fails to stop.
///
/// Returns a Future that completes when the Tor service has stopped.
Future<void> _disconnectTor(WidgetRef ref, BuildContext context) async {
  // Stop the Tor service.
  try {
    await ref.read(pTorService).stop();

    // Toggle the useTor preference on success.
    ref.read(prefsChangeNotifierProvider).useTor = false;
  } catch (e, s) {
    Logging.instance.log(
      "Error stopping tor: $e\n$s",
      level: LogLevel.Error,
    );
    // TODO: show dialog with error message
  }
}
