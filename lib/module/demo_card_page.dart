import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutero_assignment/widgets/drag_and_drop_lists.dart';
import 'demo_card_controller.dart';

class CardDemoPage extends GetView<CardDemoController> {
  static const routeName = "/projectWorkPage";
  const CardDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.5),
      appBar: AppBar(
        title: const Text("Tutero Assignment",
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
        ),
        backgroundColor: Colors.blue.withOpacity(0.5),
      ),
      body: GetBuilder<CardDemoController>(builder: (controller) {
        return controller.listDragAndDropContent.isEmpty?const SizedBox.shrink():
          DragAndDropLists(
            scrollAreaSize: Get.width * 0.2,
            listWidth: MediaQuery.of(context).size.width * 0.2,
            children: controller.listDragAndDropContent,
            onItemReorder: controller.onItemReorder,
            tabIndexCallBack: (vt) => controller.tabsIndex.value = vt,
            listPadding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                top: 10,
                bottom: 10),
            lastListTargetSize: 0,
            axis: Axis.horizontal,
            listDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[300]),
            itemDraggingWidth: Get.width * 0.2,
            itemDecorationWhileDragging: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          );
      }),
    );
  }
}
