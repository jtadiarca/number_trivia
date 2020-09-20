import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  // I don't think Future with void is a good idea
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
