import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/home/home_layout_models.dart';

/// Susunan beranda dari home CMS.
abstract class HomeRepository {
  /// Section yang aktif, terurut `sort_order`. `DataEmpty` untuk `[]` —
  /// keadaan normal di dev, dan beranda tetap utuh tanpanya.
  Future<DataState<List<HomeSectionModel>>> fetchLayout();
}
