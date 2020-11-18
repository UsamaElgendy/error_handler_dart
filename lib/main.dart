import 'package:error_handler/core/view_model/post_view_model.dart';
import 'package:error_handler/ui/view/post_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: ChangeNotifierProvider(
          create: (_) => PostViewModel(), child: PostView()),
    );
  }
}
