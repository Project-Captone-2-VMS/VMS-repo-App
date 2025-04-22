import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:vms_app/features/home/data/models/home_model.dart';
import 'package:vms_app/features/home/data/repositories/home_repository.dart';

part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepository) : super(const HomeState.initial());

  static final log = Logger('HomeCubit');

  final HomeRepository homeRepository;

  Future<void> getInformation(String token) async {
    emit(const HomeState.loading());
    try {
      final res = await homeRepository.getInformation(token);
      emit(HomeState.success(success: res));
    } catch (e) {
      log.severe('Error while trying to load HomeCubit', e);
      emit(HomeState.error(message: e.toString()));
    }
  }
}

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState.initial() = HomeStateInitial;

  const factory HomeState.loading() = HomeStateLoading;

  const factory HomeState.success({required Result success}) = HomeStateSuccess;

  const factory HomeState.error({required String message}) = HomeStateError;
}
