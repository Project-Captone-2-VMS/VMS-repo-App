import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:vms_app/features/job/data/models/job_model.dart';
import 'package:vms_app/features/job/data/repositories/job_repository.dart';

part 'job_cubit.freezed.dart';

class JobCubit extends Cubit<JobState> {
  JobCubit(this.jobRepository) : super(const JobState.initial());

  static final log = Logger('JobCubit');

  final JobRepository jobRepository;

  Future<void> getAllRoute(String username, String token) async {
    emit(const JobState.loading());
    try {
      final res = await jobRepository.getRouteByUserName(username, token);
      emit(JobState.success(success: res));
    } catch (e) {
      log.severe('Error while trying to load JobCubit', e);
      emit(JobState.error(message: e.toString()));
    }
  }

  Future<void> getRouteByRouteId(int routeId, String token) async {
    emit(const JobState.loading());
    try {
      final res = await jobRepository.getRouteByRouteId(routeId, token);
      emit(JobState.successRoute(success: res));
    } catch (e) {
      log.severe('Error while trying to load JobCubit', e);
      emit(JobState.error(message: e.toString()));
    }
  }

  Future<void> updateTimeEstimate(
    int routeId,
    int interId,
    Map<String, dynamic> data,
    String token,
  ) async {
    emit(const JobState.loading());
    try {
      await jobRepository.updateTimeEstimate(interId, data, token);

      final res = await jobRepository.getRouteByRouteId(routeId, token);
      emit(JobState.successRoute(success: res));
    } catch (e) {
      log.severe('Error while trying to load JobCubit', e);
      emit(JobState.error(message: e.toString()));
    }
  }
}

@freezed
sealed class JobState with _$JobState {
  const factory JobState.initial() = JobStateInitial;

  const factory JobState.loading() = JobStateLoading;

  const factory JobState.success({required List<Route> success}) =
      JobStateSuccess;

  const factory JobState.successRoute({required Route success}) =
      JobStateSuccessRoute;

  const factory JobState.error({required String message}) = JobStateError;
}
