import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/widget/stream_widgets.dart';

class UnPublishedProduct extends StatelessWidget {
  const UnPublishedProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return streamLoadingWidget();
  }
}
