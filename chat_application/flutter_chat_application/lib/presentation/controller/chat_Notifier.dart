import 'package:flutter/material.dart';

class ChatNotifier {
  ValueNotifier<bool> isChange = ValueNotifier(false);
  ValueNotifier<bool> isShow = ValueNotifier(false);
  FocusNode focusNode = FocusNode();
  void updateIcon(String value) {
    if (value.isNotEmpty) {
      isChange.value = true;
    } else {
      isChange.value = false;
    }
  }

  void onChangeEmoji(BuildContext context) {
    if (!isShow.value) {
      focusNode.unfocus();
    } else {
      FocusScope.of(context).requestFocus(focusNode);
    }
    isShow.value = !isShow.value;
  }

  addListenerNode() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShow.value = false;
      }
    });
  }

  void onChangekeyBoard(BuildContext context) {
    if (isShow.value) {
      focusNode.unfocus();
    } else {
      FocusScope.of(context).requestFocus(focusNode);
    }
    isShow.value = !isShow.value;
  }


}
