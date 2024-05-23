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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../themes/theme_providers.dart';

class LivingStackIcon extends ConsumerStatefulWidget {
  const LivingStackIcon({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  ConsumerState<LivingStackIcon> createState() => _LivingStackIconState();
}

class _LivingStackIconState extends ConsumerState<LivingStackIcon> {
  bool _hovering = false;

  late final VoidCallback? onPressed;

  @override
  void initState() {
    onPressed = widget.onPressed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _hovering = true;
          });
        },
        onExit: (_) {
          setState(() {
            _hovering = false;
          });
        },
        child: GestureDetector(
          onTap: () => onPressed?.call(),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: _hovering ? 1.2 : 1,
            child: SvgPicture.file(
              File(
                ref.watch(
                  themeProvider.select(
                    (value) => value.assets.stackIcon,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
