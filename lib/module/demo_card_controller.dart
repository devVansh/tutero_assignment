
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutero_assignment/widgets/drag_and_drop_item.dart';
import 'package:tutero_assignment/widgets/drag_and_drop_list.dart';

class CardDemoModel {
  final String title;
  final List<String> task;
  CardDemoModel({required this.title, required this.task});

  static List<String> listHeader = [
    "Need to do",
    "Doing",
    "Done",
    "Testing",
    "Completed"
  ];
}

class CardDemoController extends GetxController {
  CardDemoController();
  RxInt tabsIndex = 0.obs;

  List<DragAndDropList> listDragAndDropContent = [];

  @override
  void onInit() {
    super.onInit();

    listDragAndDropContent = getListDragAndDropContent();
  }


  Widget dragAndDropHeaderItem(String headerName) {
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
      child: Center(
        child: Text(
          headerName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget dragAndDropFooterItem(String headerName) {
    return InkWell(
      onTap: () {
        onTapNewItem(headerName);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white),
        child: const Center(
          child: Text(
            '+ New Task',
            style: TextStyle(
                color: Colors.blue,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget dragAndDropEmpty() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: const Center(
        child: Text("No task ...", style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  List<DragAndDropItem> getListDragAndDropItem(String headerName) {
    return headerName == CardDemoModel.listHeader.first
        ? List.generate(
            4,
            (index) => DragAndDropItem(
                  keyStr: headerName,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: Get.width,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Text('Task $index',
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ),
                ))
        : [];
  }

  List<DragAndDropList> getListDragAndDropContent() {
    List<DragAndDropList> result = [];
    result = CardDemoModel.listHeader
        .map(
          (e) => DragAndDropList(
              keyAddress: e,
              enableAddNew: false,
              canDrag: false,
              contentsWhenEmpty: dragAndDropEmpty(),
              header: dragAndDropHeaderItem(e),
              footer: dragAndDropFooterItem(e),
              children: getListDragAndDropItem(e),
              index: CardDemoModel.listHeader.indexOf(e)),
        )
        .toList();
    return result;
  }

  onTapNewItem(String headerName) {
    int index = listDragAndDropContent.indexOf(listDragAndDropContent
        .firstWhere((element) => element.keyAddress == headerName));
    listDragAndDropContent[index].enableAddNew = true;
    listDragAndDropContent[index].children.add(DragAndDropItem(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: Get.width,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: Text(
                '$headerName ${listDragAndDropContent[index].children.length}',
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          ),
        ));
    update();
  }

  onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    var movedItem =
        listDragAndDropContent[oldListIndex].children.removeAt(oldItemIndex);
    listDragAndDropContent[newListIndex]
        .children
        .insert(newItemIndex, movedItem);
    update();
  }

  onListReorder(int oldListIndex, int newListIndex) {
    var movedList = listDragAndDropContent.removeAt(oldListIndex);
    listDragAndDropContent.insert(newListIndex, movedList);
    update();
  }
}
