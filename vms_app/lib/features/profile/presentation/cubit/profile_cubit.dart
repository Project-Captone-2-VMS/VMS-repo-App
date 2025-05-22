import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:vms_app/features/profile/data/repositories/profile_repositories.dart';

part 'profile_cubit.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.profileRepositories) : super(const ProfileState.initial());

  static final log = Logger('ProfileCubit');

  final ProfileRepositories profileRepositories;

  Future<dynamic> getDriverById(String driverId, String token) async {
    emit(ProfileState.loading());
    try {
      final res = await profileRepositories.getDriverById(driverId, token);
      emit(ProfileState.success(data: res));
    } catch (e) {
      log.severe('Error while trying to load ProfileCubit', e);
      emit(ProfileState.error(message: e.toString()));
    }
  }

  Future<dynamic> updateDriverById(
    String driverId,
    Map<String, dynamic> data,
    String token,
  ) async {
    emit(ProfileState.loading());
    try {
      await profileRepositories.updateDriver(driverId, data, token);
      final res = await profileRepositories.getDriverById(driverId, token);
      emit(ProfileState.success(data: res));
    } catch (e) {
      log.severe('Error while trying to load ProfileCubit', e);
      emit(ProfileState.error(message: e.toString()));
    }
  }
}

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = ProfileStateInitial;

  const factory ProfileState.loading() = ProfileStateLoading;

  const factory ProfileState.success({required dynamic data}) =
      ProfileStateSuccess;

  const factory ProfileState.error({required String message}) =
      ProfileStateError;
}
