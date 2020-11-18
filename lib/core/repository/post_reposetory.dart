import 'dart:io';

import 'package:error_handler/core/api_services/network.dart';
import 'package:error_handler/util/failure.dart';

import '../../model/post_model.dart';

class PostRepository {
  final httpClient = ApiServices();
  Future<Post> getOnePost() async {
    try {
      final responseBody = await httpClient.getResponseBody();
      return Post.fromJson(responseBody);
    } on SocketException {
      throw Failure('No Internet Connection');
    } on HttpException {
      throw Failure('Could\'t Find the post');
    } on FormatException {
      throw Failure('Bad response Format');
    }
  }
}
