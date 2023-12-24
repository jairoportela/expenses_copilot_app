import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'expenses_categories_overview_state.dart';

class ExpensesCategoriesOverviewCubit extends Cubit<ExpensesCategoriesOverviewState> {
  ExpensesCategoriesOverviewCubit() : super(ExpensesCategoriesOverviewInitial());
}
