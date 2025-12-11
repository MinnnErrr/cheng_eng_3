import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';

@freezed
sealed class Message with _$Message {
  const factory Message({
    required bool isSuccess,
    required String message
  }) = _Message;
}
