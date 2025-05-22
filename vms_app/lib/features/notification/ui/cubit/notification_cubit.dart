import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:vms_app/features/notification/notification.dart';

part 'notification_cubit.freezed.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this.notificationRepositories)
    : super(const NotificationState.initial());

  static final log = Logger('NotificationCubit');

  final NotificationRepositories notificationRepositories;

  Future<void> getNotify(String username, String token) async {
    emit(NotificationState.loading());
    try {
      final res = await notificationRepositories.getNotify(username, token);
      emit(NotificationState.success(success: res));
    } catch (e) {
      log.severe('Error while trying to load JobCubit', e);
      emit(NotificationState.error(message: e.toString()));
    }
  }
}

@freezed
sealed class NotificationState with _$NotificationState {
  const factory NotificationState.initial() = NotificationStateInitial;

  const factory NotificationState.loading() = NotificationStateLoading;

  const factory NotificationState.success({
    required List<NotificationUserResponse>  success,
  }) = NotificationStateSuccess;

  const factory NotificationState.error({required String message}) =
      NotificationStateError;
}
