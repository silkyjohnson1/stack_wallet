/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/material.dart';
import '../utilities/constants.dart';
import 'conditional_parent.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    super.key,
    this.child,
    required this.color,
    this.padding = const EdgeInsets.all(12),
    this.radiusMultiplier = 1.0,
    this.width,
    this.height,
    this.borderColor,
    this.hoverColor,
    this.boxShadow,
    this.onPressed,
  });

  final Widget? child;
  final Color color;
  final EdgeInsets padding;
  final double radiusMultiplier;
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? hoverColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ConditionalParent(
      condition: onPressed != null,
      builder: (child) => RawMaterialButton(
        fillColor: color,
        hoverColor: hoverColor,
        elevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        padding: const EdgeInsets.all(0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Constants.size.circularBorderRadius * radiusMultiplier,
          ),
          side: borderColor == null
              ? BorderSide.none
              : BorderSide(
                  color: borderColor!,
                  width: 1.2,
                ),
        ),
        onPressed: onPressed,
        child: child,
      ),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: onPressed != null ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(
            Constants.size.circularBorderRadius * radiusMultiplier,
          ),
          border: borderColor == null ? null : Border.all(color: borderColor!),
          boxShadow: boxShadow,
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
