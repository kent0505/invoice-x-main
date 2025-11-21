import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, int> {
  HomeBloc() : super(0) {
    on<HomeEvent>(
      (event, emit) => switch (event) {
        ChangePage() => _changePage(event, emit),
      },
    );
  }

  void _changePage(
    ChangePage event,
    Emitter<int> emit,
  ) {
    emit(event.index);
  }
}
