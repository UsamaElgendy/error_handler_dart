import 'package:error_handler/core/repository/post_reposetory.dart';
import 'package:error_handler/model/post_model.dart';
import 'package:error_handler/util/failure.dart';
import 'package:flutter/material.dart';

enum NotifierState { initial, loading, loaded }

class PostViewModel extends ChangeNotifier {
  final _postService = PostRepository();

  NotifierState get state => _state;
  NotifierState _state = NotifierState.initial;

  void _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  Post get post => _post;
  Post _post;

  void _setPost(Post post) {
    _post = post;
    notifyListeners();
  }

  Failure get failure => _failure;
  Failure _failure;

  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  void getOnePost() async {
    _setState(NotifierState.loading);
    try {
      final post = await _postService.getOnePost();
      _setPost(post);
    } on Failure catch (f) {
      print(f);
      _setFailure(f);
    }
    _setState(NotifierState.loaded);
  }
}
