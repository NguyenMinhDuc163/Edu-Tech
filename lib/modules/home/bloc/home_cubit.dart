import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/home/bloc/home_state.dart';
import 'package:ed_tech/modules/home/repository/home_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo repo;

  HomeCubit({required this.repo}) : super(ProductInitial());

  Future getProduct() async {
    emit(ProductInProgress());
    try {
      final res = await repo.getProduct();
      if (res) {
        emit(ProductSuccess());
      } else {
        emit(ProductFailure());
      }
    } catch (e) {
      emit(ProductError(message: AppErrorState.getFriendlyErrorString(e)));
      throw Exception(e);
    }
  }
}
