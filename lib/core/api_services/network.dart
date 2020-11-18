import 'dart:io';

class ApiServices {
  Future<String> getResponseBody() async {
    await Future.delayed(Duration(milliseconds: 500));

    /// !No Internet Connection
    // throw SocketException('');

    ///! 404
    throw HttpException('404');

    ///! Invalid JSON (throws FormatException)
    // return 'abcd';
    // return '{"userId":1,"id":1,"title":"nice title","body":"cool body"}';
  }
}
