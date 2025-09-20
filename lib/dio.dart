import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// More examples see https://github.com/cfug/dio/tree/main/dio#examples
class Api {
  Future<Joke> getJokes() async {
    final dio = Dio();
    final response = await dio.get(
      'https://official-joke-api.appspot.com/random_joke',
    );

    if (kDebugMode) print(response.data);
    final joke = Joke.fromJson(response.data);

    if (kDebugMode) print(joke);

    return joke;
  }
}

class Joke {
  final String type;
  final String setup;
  final String punchline;
  final int id;

  const Joke({
    required this.type,
    required this.id,
    required this.setup,
    required this.punchline,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      setup: json['setup'],
      punchline: json['punchline'],
      type: json['type'],
      id: json['id'],
    );
  }
}
