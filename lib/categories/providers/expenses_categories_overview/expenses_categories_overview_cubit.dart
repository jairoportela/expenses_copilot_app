import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_copilot_app/categories/data/models/expense_category.dart';
import 'package:query_repository/query_repository.dart';

part 'expenses_categories_overview_state.dart';

class ExpensesCategoriesOverviewCubit
    extends Cubit<ExpensesCategoriesOverviewState> {
  ExpensesCategoriesOverviewCubit({required QueryRepository repository})
      : _repository = repository,
        super(ExpensesCategoriesOverviewInitial());
  final QueryRepository _repository;

  void getData() async {
    try {
      emit(ExpensesCategoriesOverviewLoading());
      final data = await _repository.getAll<ExpenseCategory>(
        queryHelper: const QueryHelper(
          tableName: 'expenses_categories',
          selectString: '*',
          fromJson: ExpenseCategory.fromJson,
          orderFilter: OrderFilter(ascending: true, columnName: 'name'),
        ),
      );
      emit(ExpensesCategoriesOverviewSuccess(data));
    } catch (error) {
      emit(ExpensesCategoriesOverviewError());
    }
  }
}
