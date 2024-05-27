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
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tuple/tuple.dart';

import '../../../../app_config.dart';
import '../../../../notifications/show_flush_bar.dart';
import '../../../../route_generator.dart';
import '../../../../themes/stack_colors.dart';
import '../../../../utilities/assets.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/logger.dart';
import '../../../../utilities/text_styles.dart';
import '../../../../utilities/util.dart';
import '../../../../widgets/background.dart';
import '../../../../widgets/conditional_parent.dart';
import '../../../../widgets/custom_buttons/app_bar_icon_button.dart';
import '../../../../widgets/desktop/desktop_dialog.dart';
import '../../../../widgets/desktop/desktop_dialog_close_button.dart';
import '../../../../widgets/desktop/primary_button.dart';
import '../../../../widgets/desktop/secondary_button.dart';
import '../../../../widgets/loading_indicator.dart';
import '../../../../widgets/stack_text_field.dart';
import 'helpers/restore_create_backup.dart';
import 'helpers/swb_file_system.dart';
import 'sub_views/stack_restore_progress_view.dart';

class RestoreFromFileView extends ConsumerStatefulWidget {
  const RestoreFromFileView({super.key});

  static const String routeName = "/restoreFromFile";

  @override
  ConsumerState<RestoreFromFileView> createState() =>
      _RestoreFromFileViewState();
}

class _RestoreFromFileViewState extends ConsumerState<RestoreFromFileView> {
  late final TextEditingController fileLocationController;
  late final TextEditingController passwordController;

  late final FocusNode passwordFocusNode;

  late final SWBFileSystem stackFileSystem;

  bool hidePassword = true;

  @override
  void initState() {
    stackFileSystem = SWBFileSystem();
    fileLocationController = TextEditingController();
    passwordController = TextEditingController();

    passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    fileLocationController.dispose();
    passwordController.dispose();

    passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Util.isDesktop;

    return ConditionalParent(
      condition: !isDesktop,
      builder: (child) {
        return Background(
          child: Scaffold(
            backgroundColor:
                Theme.of(context).extension<StackColors>()!.background,
            appBar: AppBar(
              leading: AppBarBackButton(
                onPressed: () async {
                  if (FocusScope.of(context).hasFocus) {
                    FocusScope.of(context).unfocus();
                    await Future<void>.delayed(
                      const Duration(milliseconds: 75),
                    );
                  }
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              title: Text(
                "Restore from file",
                style: STextStyles.navBarTitle(context),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: child,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      child: ConditionalParent(
        condition: isDesktop,
        builder: (child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Choose file location",
                  style:
                      STextStyles.desktopTextExtraExtraSmall(context).copyWith(
                    color:
                        Theme.of(context).extension<StackColors>()!.textDark3,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              child,
            ],
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              autocorrect: Util.isDesktop ? false : true,
              enableSuggestions: Util.isDesktop ? false : true,
              onTap: () async {
                try {
                  await stackFileSystem.prepareStorage();
                  if (mounted) {
                    await stackFileSystem.openFile(context);
                  }

                  if (mounted) {
                    setState(() {
                      fileLocationController.text =
                          stackFileSystem.filePath ?? "";
                    });
                  }
                } catch (e, s) {
                  Logging.instance.log("$e\n$s", level: LogLevel.Error);
                }
              },
              controller: fileLocationController,
              style: STextStyles.field(context),
              decoration: InputDecoration(
                hintText: "Choose file...",
                hintStyle: STextStyles.fieldLabel(context),
                suffixIcon: UnconstrainedBox(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      SvgPicture.asset(
                        Assets.svg.folder,
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .textDark3,
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                ),
              ),
              key: const Key("restoreFromFileLocationTextFieldKey"),
              readOnly: true,
              toolbarOptions: const ToolbarOptions(
                copy: true,
                cut: false,
                paste: false,
                selectAll: false,
              ),
              onChanged: (newValue) {},
            ),
            SizedBox(
              height: !isDesktop ? 8 : 24,
            ),
            if (isDesktop)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Enter passphrase",
                  style:
                      STextStyles.desktopTextExtraExtraSmall(context).copyWith(
                    color:
                        Theme.of(context).extension<StackColors>()!.textDark3,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                Constants.size.circularBorderRadius,
              ),
              child: TextField(
                key: const Key("restoreFromFilePasswordFieldKey"),
                focusNode: passwordFocusNode,
                controller: passwordController,
                style: STextStyles.field(context),
                obscureText: hidePassword,
                enableSuggestions: false,
                autocorrect: false,
                decoration: standardInputDecoration(
                  "Enter passphrase",
                  passwordFocusNode,
                  context,
                ).copyWith(
                  labelStyle:
                      isDesktop ? STextStyles.fieldLabel(context) : null,
                  suffixIcon: UnconstrainedBox(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        GestureDetector(
                          key: const Key(
                            "restoreFromFilePasswordFieldShowPasswordButtonKey",
                          ),
                          onTap: () async {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          child: SvgPicture.asset(
                            hidePassword ? Assets.svg.eye : Assets.svg.eyeSlash,
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .textDark3,
                            width: 16,
                            height: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            if (!isDesktop) const Spacer(),
            !isDesktop
                ? TextButton(
                    style: passwordController.text.isEmpty ||
                            fileLocationController.text.isEmpty
                        ? Theme.of(context)
                            .extension<StackColors>()!
                            .getPrimaryDisabledButtonStyle(context)
                        : Theme.of(context)
                            .extension<StackColors>()!
                            .getPrimaryEnabledButtonStyle(context),
                    onPressed: passwordController.text.isEmpty ||
                            fileLocationController.text.isEmpty
                        ? null
                        : () async {
                            final String fileToRestore =
                                fileLocationController.text;
                            final String passphrase = passwordController.text;

                            if (FocusScope.of(context).hasFocus) {
                              FocusScope.of(context).unfocus();
                              await Future<void>.delayed(
                                const Duration(milliseconds: 75),
                              );
                            }

                            if (!(await File(fileToRestore).exists())) {
                              await showFloatingFlushBar(
                                type: FlushBarType.warning,
                                message: "Backup file does not exist",
                                context: context,
                              );
                              return;
                            }

                            bool shouldPop = false;
                            unawaited(
                              showDialog<dynamic>(
                                barrierDismissible: false,
                                context: context,
                                builder: (_) => WillPopScope(
                                  onWillPop: () async {
                                    return shouldPop;
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: Center(
                                          child: Text(
                                            "Decrypting Stack backup file",
                                            style: STextStyles.pageTitleH2(
                                              context,
                                            ).copyWith(
                                              color: Theme.of(context)
                                                  .extension<StackColors>()!
                                                  .textWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 64,
                                      ),
                                      const Center(
                                        child: LoadingIndicator(
                                          width: 100,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            final String? jsonString = await compute(
                              SWB.decryptStackWalletWithPassphrase,
                              Tuple2(fileToRestore, passphrase),
                              debugLabel: "stack wallet decryption compute",
                            );

                            if (mounted) {
                              // pop LoadingIndicator
                              shouldPop = true;
                              Navigator.of(context).pop();

                              passwordController.text = "";

                              if (jsonString == null) {
                                await showFloatingFlushBar(
                                  type: FlushBarType.warning,
                                  message: "Failed to decrypt backup file",
                                  context: context,
                                );
                                return;
                              }

                              await Navigator.of(context).push(
                                RouteGenerator.getRoute(
                                  builder: (_) => StackRestoreProgressView(
                                    jsonString: jsonString,
                                    shouldPushToHome: true,
                                  ),
                                ),
                              );
                            }
                          },
                    child: Text(
                      "Restore",
                      style: STextStyles.button(context),
                    ),
                  )
                : Row(
                    children: [
                      PrimaryButton(
                        width: 183,
                        buttonHeight: ButtonHeight.m,
                        label: "Restore",
                        enabled: !(passwordController.text.isEmpty ||
                            fileLocationController.text.isEmpty),
                        onPressed: passwordController.text.isEmpty ||
                                fileLocationController.text.isEmpty
                            ? null
                            : () async {
                                final String fileToRestore =
                                    fileLocationController.text;
                                final String passphrase =
                                    passwordController.text;

                                if (FocusScope.of(context).hasFocus) {
                                  FocusScope.of(context).unfocus();
                                  await Future<void>.delayed(
                                    const Duration(milliseconds: 75),
                                  );
                                }

                                if (!(await File(fileToRestore).exists())) {
                                  await showFloatingFlushBar(
                                    type: FlushBarType.warning,
                                    message: "Backup file does not exist",
                                    context: context,
                                  );
                                  return;
                                }

                                bool shouldPop = false;
                                unawaited(
                                  showDialog<dynamic>(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (_) => WillPopScope(
                                      onWillPop: () async {
                                        return shouldPop;
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Material(
                                            color: Colors.transparent,
                                            child: Center(
                                              child: Text(
                                                "Decrypting Stack backup file",
                                                style: STextStyles.pageTitleH2(
                                                  context,
                                                ).copyWith(
                                                  color: Theme.of(context)
                                                      .extension<StackColors>()!
                                                      .textWhite,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 64,
                                          ),
                                          const Center(
                                            child: LoadingIndicator(
                                              width: 100,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                                final String? jsonString = await compute(
                                  SWB.decryptStackWalletWithPassphrase,
                                  Tuple2(fileToRestore, passphrase),
                                  debugLabel: "stack wallet decryption compute",
                                );

                                if (mounted) {
                                  // pop LoadingIndicator
                                  shouldPop = true;
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();

                                  passwordController.text = "";

                                  if (jsonString == null) {
                                    await showFloatingFlushBar(
                                      type: FlushBarType.warning,
                                      message: "Failed to decrypt backup file",
                                      context: context,
                                    );
                                    return;
                                  }

                                  await showDialog<dynamic>(
                                    context: context,
                                    useSafeArea: false,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return DesktopDialog(
                                        maxHeight: 750,
                                        maxWidth: 600,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return SingleChildScrollView(
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  minHeight:
                                                      constraints.maxHeight,
                                                ),
                                                child: IntrinsicHeight(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(
                                                              32,
                                                            ),
                                                            child: Text(
                                                              "Restore ${AppConfig.appName}",
                                                              style: STextStyles
                                                                  .desktopH3(
                                                                context,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          const DesktopDialogCloseButton(),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 32,
                                                        ),
                                                        child:
                                                            StackRestoreProgressView(
                                                          jsonString:
                                                              jsonString,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 32,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      SecondaryButton(
                        width: 183,
                        buttonHeight: ButtonHeight.m,
                        label: "Cancel",
                        onPressed: () {},
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
