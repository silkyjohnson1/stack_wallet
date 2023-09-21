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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:stackwallet/providers/global/prefs_provider.dart';
import 'package:stackwallet/services/event_bus/events/global/tor_connection_status_changed_event.dart';
import 'package:stackwallet/services/tor_service.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/utilities/stack_file_system.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/conditional_parent.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/custom_buttons/draggable_switch_button.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';
import 'package:stackwallet/widgets/stack_dialog.dart';
import 'package:stackwallet/widgets/tor_subscription.dart';

class TorSettingsView extends ConsumerStatefulWidget {
  const TorSettingsView({
    Key? key,
  }) : super(key: key);

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
                      return StackDialog(
                        title: "What is Tor?",
                        message:
                            "Short for \"The Onion Router\", is an open-source software that enables internet communication"
                            " to remain anonymous by routing internet traffic through a series of layered nodes,"
                            " to obscure the origin and destination of data.",
                        rightButton: SecondaryButton(
                          label: "Close",
                          onPressed: Navigator.of(context).pop,
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
                    child: TorAnimatedButton(),
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
                                        return StackDialog(
                                          title: "What is Tor killswitch?",
                                          message:
                                              "A security feature that protects your information from accidental exposure by"
                                              " disconnecting your device from the Tor network if the"
                                              " connection is disrupted or compromised.",
                                          rightButton: SecondaryButton(
                                            label: "Close",
                                            onPressed:
                                                Navigator.of(context).pop,
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
                                      .select((value) => value.torKillSwitch),
                                ),
                                onValueChanged: (newValue) {
                                  ref
                                      .read(prefsChangeNotifierProvider)
                                      .torKillSwitch = newValue;
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

class TorAnimatedButton extends ConsumerStatefulWidget {
  const TorAnimatedButton({super.key});

  @override
  ConsumerState<TorAnimatedButton> createState() => _TorAnimatedButtonState();
}

class _TorAnimatedButtonState extends ConsumerState<TorAnimatedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller1;

  late TorConnectionStatus _status;

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
          await connectTor(ref, context);
          break;

        case TorConnectionStatus.connected:
          await disconnectTor(ref, context);

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

  Future<void> _playPlug() async {
    await _play(
      from: "0.0",
      to: "connecting-start",
      repeat: false,
    );
  }

  Future<void> _playConnecting({double? start}) async {
    await _play(
      from: start?.toString() ?? "connecting-start",
      to: "connecting-end",
      repeat: true,
    );
  }

  Future<void> _playConnectingDone() async {
    await _play(
      from: "${controller1.value}",
      to: "connected-start",
      repeat: false,
    );
  }

  Future<void> _playConnected() async {
    await _play(
      from: "connected-start",
      to: "connected-end",
      repeat: true,
    );
  }

  Future<void> _playDisconnect() async {
    await _play(
      from: "disconnection-start",
      to: "disconnection-end",
      repeat: false,
    );
    controller1.reset();
  }

  Future<void> _play({
    required String from,
    required String to,
    required bool repeat,
  }) async {
    final composition = await _completer.future;
    final start = double.tryParse(from) ?? composition.getMarker(from)!.start;
    final end = composition.getMarker(to)!.start;

    controller1.value = start;

    if (repeat) {
      await controller1.repeat(
        min: start,
        max: end,
        period: composition.duration * (end - start),
      );
    } else {
      await controller1.animateTo(
        end,
        duration: composition.duration * (end - start),
      );
    }
  }

  late Completer<LottieComposition> _completer;

  @override
  void initState() {
    controller1 = AnimationController(vsync: this);

    _status = ref.read(pTorService).status;

    _completer = Completer();

    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 1.5;

    return TorSubscription(
      onTorStatusChanged: (status) async {
        _status = status;
        switch (_status) {
          case TorConnectionStatus.disconnected:
            await _playDisconnect();
            break;

          case TorConnectionStatus.connected:
            await _playConnectingDone();
            await _playConnected();
            break;

          case TorConnectionStatus.connecting:
            await _playPlug();
            await _playConnecting();
            break;
        }
      },
      child: ConditionalParent(
        condition: _status != TorConnectionStatus.connecting,
        builder: (child) => GestureDetector(
          onTap: onTap,
          child: child,
        ),
        child: Column(
          children: [
            SizedBox(
              width: width,
              child: Lottie.asset(
                Assets.lottie.onionTor,
                controller: controller1,
                width: width,
                // height: width,
                onLoaded: (composition) {
                  _completer.complete(composition);
                  controller1.duration = composition.duration;

                  if (_status == TorConnectionStatus.connected) {
                    _playConnected();
                  } else if (_status == TorConnectionStatus.connecting) {
                    _playConnecting();
                  }
                },
              ),
            ),
            const UpperCaseTorText(),
          ],
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
          await connectTor(ref, context);
          break;

        case TorConnectionStatus.connected:
          await disconnectTor(ref, context);

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
    _status = ref.read(pTorService).status;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TorSubscription(
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

class UpperCaseTorText extends ConsumerStatefulWidget {
  const UpperCaseTorText({super.key});

  @override
  ConsumerState<UpperCaseTorText> createState() => _UpperCaseTorTextState();
}

class _UpperCaseTorTextState extends ConsumerState<UpperCaseTorText> {
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

  @override
  void initState() {
    _status = ref.read(pTorService).status;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TorSubscription(
        onTorStatusChanged: (status) {
          setState(() {
            _status = status;
          });
        },
        child: Text(
          _label(
            _status,
          ),
          style: STextStyles.pageTitleH2(
            context,
          ).copyWith(
            color: _color(
              _status,
              Theme.of(context).extension<StackColors>()!,
            ),
          ),
        ));
  }
}

/// Connect to the Tor network.
///
/// This method is called when the user taps the "Connect" button.
///
/// Throws an exception if the Tor service fails to start.
///
/// Returns a Future that completes when the Tor service has started.
Future<void> connectTor(WidgetRef ref, BuildContext context) async {
  try {
    // Init the Tor service if it hasn't already been.
    final torDir = await StackFileSystem.applicationTorDirectory();
    ref.read(pTorService).init(torDataDirPath: torDir.path);
    // Start the Tor service.
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
}

/// Disconnect from the Tor network.
///
/// This method is called when the user taps the "Disconnect" button.
///
/// Throws an exception if the Tor service fails to stop.
///
/// Returns a Future that completes when the Tor service has stopped.
Future<void> disconnectTor(WidgetRef ref, BuildContext context) async {
  // Stop the Tor service.
  try {
    await ref.read(pTorService).disable();

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
