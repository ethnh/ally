import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';



class MyWebIndexPage extends StatefulWidget {
  @override
  _MyWebIndexPageState createState() => _MyWebIndexPageState();
}

class _MyWebIndexPageState extends State<MyWebIndexPage> {
  QuillController _controller = QuillController.basic();
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quill Rich Text Editor")),
      body: Column(
        children: [
          QuillToolbar.basic(controller: _controller),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: QuillEditor.basic(
                controller: _controller,
                readOnly: false, // true for view only mode
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
