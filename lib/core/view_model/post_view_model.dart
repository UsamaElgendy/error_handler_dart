import 'package:dartz/dartz.dart';
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

  // Post get post => _post;
  // Post _post;
  //
  // void _setPost(Post post) {
  //   _post = post;
  //   notifyListeners();
  // }

  /// With FP
  Either<Failure, Post> get post => _post;
  Either<Failure, Post> _post;

  void _setPost(Either<Failure, Post> post) {
    _post = post;
    notifyListeners();
  }

  // Failure get failure => _failure;
  // Failure _failure;
  //
  // void _setFailure(Failure failure) {
  //   _failure = failure;
  //   notifyListeners();
  // }

  void getOnePost() async {
    _setState(NotifierState.loading);
    await Task(() => _postService.getOnePost())
        // Automatically catches exceptions
        // This automatically catches all exceptions
        // and feeds them into the left side of Either<Object, Post>
        .attempt()
        // now we need to cast the left side to Failure class
        .map(
          (either) => either.leftMap((obj) {
            try {
              return obj as Failure;
            } catch (e) {
              throw obj;
            }
          }),
        )
        // Converts Task back into a Future
        .run()
        // Classic Future continuation
        .then((value) => _setPost(value));

    /// Without FP
    // final post = await _postService.getOnePost();
    // _setPost(post);

    _setState(NotifierState.loaded);
  }
}
