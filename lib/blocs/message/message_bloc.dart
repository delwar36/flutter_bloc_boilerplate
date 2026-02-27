import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'message_event.dart';
import 'message_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageInit()) {
    on<OnMessage>((event, emit) {
      emit(MessageShow(text: event.message));
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
