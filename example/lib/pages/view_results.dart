import 'dart:typed_data';

import 'package:flutter/material.dart';

void showViewResult(BuildContext context, Uint8List bytes) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ViewResults(bytes)),
  );
}

class ViewResults extends StatefulWidget {
  final Uint8List bytes;
  const ViewResults(this.bytes, {Key? key}) : super(key: key);

  @override
  State<ViewResults> createState() => _ViewResultsState();
}

class _ViewResultsState extends State<ViewResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View result page")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // child: Center(child: Image.file(file)),
        child: Center(child: Image.memory(widget.bytes)),
      ),
    );
  }
}
