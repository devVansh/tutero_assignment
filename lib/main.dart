import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tutero_assignment/module/demo_card_binding.dart';
import 'package:tutero_assignment/module/demo_card_page.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: const CardDemoPage(),
    initialBinding: CardDemoBinding(),
  ));
}
