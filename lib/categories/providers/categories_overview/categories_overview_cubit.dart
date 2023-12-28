import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_copilot_app/categories/data/models/models.dart';
import 'package:expenses_copilot_app/categories/data/repositories/category_repository.dart';

part 'categories_overview_state.dart';

class CategoriesOverviewCubit extends Cubit<CategoriesOverviewState> {
  CategoriesOverviewCubit({required CategoryRepository repository})
      : _repository = repository,
        super(CategoriesOverviewInitial());
  final CategoryRepository _repository;

  void getData({required CategoryType type}) async {
    try {
      emit(CategoriesOverviewLoading());
      final data = await _repository.getAll(type: type);
      emit(CategoriesOverviewSuccess(data));
    } catch (error) {
      emit(CategoriesOverviewError());
    }
  }
}
