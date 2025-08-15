class Result<T> {
  final T? _error;

  Result._(this._error);

  factory Result.success() => Result._(null);
  factory Result.failure(T error) => Result._(error);

  bool get isSuccess => _error == null;

  T get error {
    if (isSuccess) throw StateError("No error in a successful result");
    return _error!;
  }

  void fold({
    required void Function() onSuccess,
    required void Function(T error) onFailure,
  }) {
    if (isSuccess) {
      onSuccess();
    } else {
      onFailure(_error as T);
    }
  }
}
