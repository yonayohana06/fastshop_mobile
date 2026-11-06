import 'dart:async';

/// Jembatan antara layer network dan AuthBloc.
/// Interceptor memanggil [notifyUnauthorized] saat server membalas 401,
/// lalu AuthBloc mendengarkan dan melakukan logout.
class SessionEvents {
  final _controller = StreamController<void>.broadcast();

  Stream<void> get onUnauthorized => _controller.stream;

  void notifyUnauthorized() => _controller.add(null);

  void dispose() => _controller.close();
}
