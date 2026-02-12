import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../models/{{feature_name.snakeCase()}}_model.dart';

part '{{feature_name.snakeCase()}}_service.g.dart';

@RestApi()
@LazySingleton()
abstract class {{feature_name.pascalCase()}}Service {
  @factoryMethod
  factory {{feature_name.pascalCase()}}Service(Dio dio) = _{{feature_name.pascalCase()}}Service;

  @GET(ApiConstants.{{feature_name.camelCase()}}s)
  Future<List<{{feature_name.pascalCase()}}Model>> get{{feature_name.pascalCase()}}s({@Queries() Map<String, dynamic>? params});

  @GET('${ApiConstants.{{feature_name.camelCase()}}s}/{id}')
  Future<{{feature_name.pascalCase()}}Model> get{{feature_name.pascalCase()}}Detail(@Path('id') String id);

  @POST(ApiConstants.{{feature_name.camelCase()}}s)
  Future<{{feature_name.pascalCase()}}Model> create{{feature_name.pascalCase()}}(@Body() {{feature_name.pascalCase()}}Model data);

  @PUT('${ApiConstants.{{feature_name.camelCase()}}s}/{id}')
  Future<{{feature_name.pascalCase()}}Model> update{{feature_name.pascalCase()}}(
    @Path('id') String id,
    @Body() {{feature_name.pascalCase()}}Model data,
  );

  @DELETE('${ApiConstants.{{feature_name.camelCase()}}s}/{id}')
  Future<dynamic> delete{{feature_name.pascalCase()}}(@Path('id') String id);
}
