import 'dart:async';

class Bloc {
  final _streamControllers = List<StreamController>();

  StreamController<T> createStreamController<T>() {
    final controller = StreamController<T>();
    _streamControllers.add(controller);
    return controller;
  }

  void dispose() {
    _streamControllers.forEach((controller) => controller.close());
  }
}
