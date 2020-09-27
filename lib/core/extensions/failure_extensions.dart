import '../error/failure_messages.dart';
import '../error/failures.dart';

extension MapTo on Failure {
  String toMessage() {
    switch (this.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
