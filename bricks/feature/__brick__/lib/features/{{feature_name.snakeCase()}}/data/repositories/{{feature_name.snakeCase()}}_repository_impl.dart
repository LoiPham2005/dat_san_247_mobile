import 'package:injectable/injectable.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import '../../domain/entities/{{feature_name.snakeCase()}}.dart';
import '../../domain/repositories/{{feature_name.snakeCase()}}_repository.dart';
import '../datasources/{{feature_name.snakeCase()}}_remote_datasource.dart';

@LazySingleton(as: {{feature_name.pascalCase()}}Repository)
class {{feature_name.pascalCase()}}RepositoryImpl implements {{feature_name.pascalCase()}}void Repository {
  final {{feature_name.pascalCase()}}RemoteDataSource remoteDataSource;

  {{feature_name.pascalCase()}}RepositoryImpl(this._remoteDataSource);

  {{#has_list}}
  @override
  Future<Result<List<{{feature_name.pascalCase()}}>>> get{{feature_name.pascalCase()}}Future<dynamic> s({
    Map<String, dynamic>? params,
  }) async {
    final result = await remoteDataSource.get{{feature_name.pascalCase()}}s(params: params);
    return result.mapItems((model) => model.toEntity());
  }
  {{/has_list}}

  {{#has_detail}}
  @override
  Future<Result<{{feature_name.pascalCase()}}>> get{{feature_name.pascalCase()}}Future<dynamic> Detail(String id) async {
    final result = await remoteDataSource.get{{feature_name.pascalCase()}}Detail(id);
    return result.map((model) => model.toEntity());
  }
  {{/has_detail}}

  {{#has_create}}
  @override
  Future<Result<{{feature_name.pascalCase()}}>> create{{feature_name.pascalCase()}}(Map<String, dynamic> data) async {
    final result = await remoteDataSource.create{{feature_name.pascalCase()}}(data);
    return result.map((model) => model.toEntity());
  }
  {{/has_create}}

  {{#has_update}}
  @override
  Future<Result<{{feature_name.pascalCase()}}>> update{{feature_name.pascalCase()}}(
    String id,
    Map<String, dynamic> data,
  ) async {
    final result = await remoteDataSource.update{{feature_name.pascalCase()}}(id, data);
    return result.map((model) => model.toEntity());
  }
  {{/has_update}}

  {{#has_delete}}
  @override
  Future<Result<bool>> delete{{feature_name.pascalCase()}}(String id) async {
    return await remoteDataSource.delete{{feature_name.pascalCase()}}(id);
  }
  {{/has_delete}}
}
