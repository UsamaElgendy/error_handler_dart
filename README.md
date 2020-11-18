# Error Handler


### An exception is an error that takes place inside the program.When an exception occurs inside a program the normal flow of the program is disrupted and it terminates abnormally, displaying the error and exception stack as output

- we can use FutureBuilder and handle error in it —> But it's wrong and using a lot of resources
- What if there is some unrecoverable error upon which it's better to let the app crash?

```dart
FutureBuilder<Post>(
  future: postFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      final error = snapshot.error;
      return StyledText(error.toString());
    } else if (snapshot.hasData) {
      final post = snapshot.data;
      return StyledText(post.toString());
    } else {
      return StyledText('Press the button 👇');
    }
  },
),
```

## Customizing error messages ✍

Catching only particular types of exceptions and then customizing error messages is a better option. However, we mustn't let ourselves slip into just printing out the messages, because they will again not be shown in the UI

```dart
Future<Post> getOnePost() async {
    // Printing is nice, but we want these messages in the UI
    try {
      final responseBody = await httpClient.getResponseBody();
      return Post.fromJson(responseBody);
    } on SocketException {
      print('No Internet connection 😑');
    } on HttpException {
      print("Couldn't find the post 😱");
    } on FormatException {
      print("Bad response format 👎");
    }
  }
```


The trick is to create a single app-wide Failure class used solely for the purpose of getting error messages to the UI / the state management solution of your choice. Basically, instead of printing the error messages, you'll throw a new instance of Failure.

1- Create Class Failure

```dart
class Failure {
  // Use something like "int code;" if you want to translate error messages
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}
```

and throw the  Exception

```dart
Future<Post> getOnePost() async {
    try {
      final responseBody = await httpClient.getResponseBody();
      return Post.fromJson(responseBody);
    } on SocketException {
      throw Failure('No Internet connection 😑');
    } on HttpException {
      throw Failure("Couldn't find the post 😱");
    } on FormatException {
      throw Failure("Bad response format 👎");
    }
  }
}
```

now we work with stateFull and FutureBuilder  , but we will need to work with provider or any state management

.. make View model

```dart
enum NotifierState { initial, loading, loaded }

class PostViewModel extends ChangeNotifier {
  final _postService = PostService();

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;
  void _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  Post _post;
  Post get post => _post;
  void _setPost(Post post) {
    _post = post;
    notifyListeners();
  }

  Failure _failure;
  Failure get failure => _failure;
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
      _setFailure(f);
    }
    _setState(NotifierState.loaded);
  }
}
```

### With proper state management solutions like change notifier, you might be tempted to not have an app-specific Failure class to which all "catchable" errors are converted in an outside world boundary class like PostService. Instead, you may want to catch exceptions directly in the ChangeNotifier and convert them to messages right there. I would advise against it, as it's best to catch errors closest to their source, not a few layers away. Even error handling should follow the single responsibility principle!