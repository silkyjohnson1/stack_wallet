/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../app_config.dart';
import 'logger.dart';
import 'util.dart';

abstract class StackFileSystem {
  static String? _overrideDesktopDirPath;
  static bool _overrideDirSet = false;
  static void setDesktopOverrideDir(String dirPath) {
    if (_overrideDirSet) {
      throw Exception(
        "Attempted to change StackFileSystem._overrideDir unexpectedly",
      );
    }
    _overrideDesktopDirPath = dirPath;
    _overrideDirSet = true;
  }

  static Future<Directory> applicationRootDirectory() async {
    Directory appDirectory;

    // todo: can merge and do same as regular linux home dir?
    if (Logging.isArmLinux) {
      appDirectory = await getApplicationDocumentsDirectory();
      appDirectory =
          Directory("${appDirectory.path}/.${AppConfig.appDefaultDataDirName}");
    } else if (Platform.isLinux) {
      if (_overrideDesktopDirPath != null) {
        appDirectory = Directory(_overrideDesktopDirPath!);
      } else {
        appDirectory = Directory(
          "${Platform.environment['HOME']}/.${AppConfig.appDefaultDataDirName}",
        );
      }
    } else if (Platform.isWindows) {
      if (_overrideDesktopDirPath != null) {
        appDirectory = Directory(_overrideDesktopDirPath!);
      } else {
        appDirectory = await getApplicationSupportDirectory();
      }
    } else if (Platform.isMacOS) {
      if (_overrideDesktopDirPath != null) {
        appDirectory = Directory(_overrideDesktopDirPath!);
      } else {
        appDirectory = await getLibraryDirectory();
        appDirectory = Directory(
          "${appDirectory.path}/${AppConfig.appDefaultDataDirName}",
        );
      }
    } else if (Platform.isIOS) {
      // todo: check if we need different behaviour here
      if (Util.isDesktop) {
        appDirectory = await getLibraryDirectory();
      } else {
        appDirectory = await getLibraryDirectory();
      }
    } else if (Platform.isAndroid) {
      appDirectory = await getApplicationDocumentsDirectory();
    } else {
      throw Exception("Unsupported platform");
    }
    if (!appDirectory.existsSync()) {
      await appDirectory.create(recursive: true);
    }
    return appDirectory;
  }

  static Future<Directory> applicationIsarDirectory() async {
    final root = await applicationRootDirectory();
    if (Util.isDesktop) {
      final dir = Directory("${root.path}/isar");
      if (!dir.existsSync()) {
        await dir.create();
      }
      return dir;
    } else {
      return root;
    }
  }

  static Future<Directory> applicationTorDirectory() async {
    final root = await applicationRootDirectory();
    if (Util.isDesktop) {
      final dir = Directory("${root.path}/tor");
      if (!dir.existsSync()) {
        await dir.create();
      }
      return dir;
    } else {
      return root;
    }
  }

  static Future<Directory> applicationHiveDirectory() async {
    final root = await applicationRootDirectory();
    if (Util.isDesktop) {
      final dir = Directory("${root.path}/hive");
      if (!dir.existsSync()) {
        await dir.create();
      }
      return dir;
    } else {
      return root;
    }
  }

  static Future<void> initThemesDir() async {
    final root = await applicationRootDirectory();

    final dir = Directory("${root.path}/themes");
    if (!dir.existsSync()) {
      await dir.create();
    }
    themesDir = dir;
  }

  static Directory? themesDir;
}
