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
import 'package:stackwallet/utilities/text_styles.dart';

class AppBarSearchField extends StatefulWidget {
  const AppBarSearchField({
    Key? key,
    required this.controller,
    this.focusNode,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  State<AppBarSearchField> createState() => _AppBarSearchFieldState();
}

class _AppBarSearchFieldState extends State<AppBarSearchField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: TextField(
            autofocus: true,
            focusNode: widget.focusNode,
            controller: widget.controller,
            style: STextStyles.field(context),
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              hintText: "Search...",
              hintStyle: STextStyles.fieldLabel(context),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
