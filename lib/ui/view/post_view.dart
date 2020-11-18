import 'package:error_handler/core/repository/post_reposetory.dart';
import 'package:error_handler/core/view_model/post_view_model.dart';
import 'package:error_handler/ui/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostView extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<PostView> {
  final postRepository = PostRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Handling'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Consumer<PostViewModel>(
              builder: (_, notifier, __) {
                if (notifier.state == NotifierState.initial) {
                  return StyledText('Press the button 👇');
                } else if (notifier.state == NotifierState.loading) {
                  return CircularProgressIndicator();
                } else {
                  if (notifier.failure != null) {
                    return StyledText(notifier.failure.toString());
                  } else {
                    return StyledText(notifier.post.toString());
                  }
                }
              },
            ),
            RaisedButton(
              child: Text('Get Post'),
              onPressed: () async {
                setState(() {
                  Provider.of<PostViewModel>(context, listen: false)
                      .getOnePost();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
