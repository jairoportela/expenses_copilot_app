import 'package:expenses_copilot_app/monthly_statistics/data/models/monthly_summary.dart';
import 'package:query_repository/query_repository.dart';

abstract class MonthlySummaryRepository {
  Stream<MonthlySummary> getSummary({required DateTime month});
}

class MonthlySummaryRepositoryImplementation extends MonthlySummaryRepository {
  MonthlySummaryRepositoryImplementation({required QueryRepository dataSource})
      : _dataSource = dataSource;
  final QueryRepository _dataSource;

  static const _tableName = 'monthly_statistics';

  @override
  Stream<MonthlySummary> getSummary({required DateTime month}) {
    return _dataSource
        .subscribe(
          subscribeHelper:
              const SubscribeHelper(tableName: _tableName, primaryKey: ['id']),
        )
        .eq('month', month.toIso8601String())
        .map((event) {
      try {
        if (event.isEmpty) {
          return MonthlySummary.empty(month);
        }
        final value = MonthlySummary.fromJson(event[0]);

        return value;
      } catch (error) {
        return MonthlySummary.empty(month);
      }
    });
  }
}
