import 'package:get/get.dart';
import 'package:tutero_assignment/module/demo_card_controller.dart';

class CardDemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CardDemoController>(() => CardDemoController());
  }
}
