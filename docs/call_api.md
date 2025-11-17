# Clean Architecture API Implementation Guide

feature/
├── data/
│   ├── datasources/
│   │   └── feature_remote_datasource.dart
│   ├── models/
│   │   └── feature_model.dart
│   └── repositories/
│       └── feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── feature.dart
│   ├── repositories/
│   │   └── feature_repository.dart
│   └── usecases/
│       └── feature_usecases.dart
└── presentation/
    ├── bloc/
    │   └── feature_bloc.dart
    ├── pages/
    │   └── feature_page.dart
    └── widgets/


# I. domain
# 1. Create Entity (`domain/entities/feature_entity.dart`):
```dart
class Feature extends Equatable {
  final int id;
  final String name;
  // Add other properties

  const Feature({
    required this.id, 
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
```

# 2. Create repositories (`domain/repositorie/feature_repositories.dart`):
```dart
  abstract class FeatureRepository {
    Future<Result<List<Feature>>> getFeatures();
    Future<Result<Feature>> getFeatureDetail(String id);
    Future<Result<Feature>> createFeature(Map<String, dynamic> data);
    Future<Result<Feature>> updateFeature(String id, Map<String, dynamic> data);
    Future<Result<bool>> deleteFeature(String id);
    }
```
# 3. Create usecases (`domain/usecases/feature_usecases.dart`):
```dart
@injectable
class GetFeaturesUseCase {
  final FeatureRepository repository;
  GetFeaturesUseCase(this.repository);

  Future<Result<List<Feature>>> call({Map<String, dynamic>? params}) {
    return repository.getFeatures(params: params);
  }
}
```

# II. Data Layer
# 4. Create models (`domain/models/feature_models.dart`):
```dart
    class FeatureModel extends Feature {
        const FeatureModel({
            required super.id,
            required super.name,
        });

        factory FeatureModel.fromJson(Map<String, dynamic> json) {
            return FeatureModel(
            id: json['id'],
            name: json['name'],
            );
        }

        Feature toEntity() {
            return Feature(
            id: id,
            name: name,
            );
        }
    }
```
# 2. Create datasources (`domain/datasources/feature_remote_datasource.dart`):
```dart
abstract class FeatureRemoteDataSource {
    Future<Result<List<FeatureModel>>> getFeatures({Map<String, dynamic>? params}) 
}

@LazySingleton(as: FeatureRemoteDataSource)
class FeatureRemoteDataSourceImpl  
    implements FeatureRemoteDataSource {
  final ApiClient _apiClient;
  
  FeatureRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<FeatureModel>>> getFeatures({Map<String, dynamic>? params}) {
    return _apiClient.getResult(
      ApiConstants.features,
      (json) {
        final list = (json['data'] ?? json) as List;
        return list.map((e) => FeatureModel.fromJson(e)).toList();
      },
      queryParameters: params,
    );
  }
}
```
# 3. Create repositories (`domain/repositories/feature_repository_impl.dart`):
```dart
@LazySingleton(as: FeatureRepository)
class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource _remoteDataSource;

  FeatureRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<FeatureModel>>> getFeatures({Map<String, dynamic>? params}) async {
    final result = await _remoteDataSource.getFeatures(params: params);
    return result.map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<Result<FeatureModel>> getgetFeaturesDetail(String id) async {
    final result = await _remoteDataSource.getgetFeaturesDetail(id);
    return result.map((model) => model.toEntity());
  }
}
```


2.3. Presentation Layer 
# bloc
```dart bloc

class FetchDataListEvent extends BaseEvent {
  final Map<String, dynamic>? params;
  final bool refresh;

  const FetchDataListEvent({
    this.params,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [params, refresh];
}

@injectable
class FeatureBloc extends Bloc<BaseEvent, BaseState> {
  final GetFeaturesUseCase _getFeaturesUseCase;

  FeatureBloc({required GetFeaturesUseCase getFeaturesUseCase})
      : _getFeaturesUseCase = getFeaturesUseCase,
        super(BaseState.initial()) {
    on<FetchDataListEvent>(_onFetchFeatures);
  }

  Future<void> _onFetchFeatures(
    FetchDataListEvent event,
    Emitter<BaseState> emit,
  ) async {
    await execute(
      event,
      emit,
      () => _getFeaturesUseCase(params: event.params),
    );
  }
}
```

# cubit
```dart
@injectable
class AuthCubit extends BaseCubit<void> {
  final LoginUseCase _loginUseCase;

  AuthCubit(this._loginUseCase);

  Future<void> login({
    required String email,
    required String password,
  }) async {
     await execute(
      action: () => _loginUseCase(
        email: email,
        password: password,
      ),
    );
  }
}
```

# getX
 ```dart
@injectable
class AuthController extends BaseController {
  final LoginUseCase _loginUseCase;

  AuthController(this._loginUseCase,);

  final Rx<AuthResponse?> user = Rx<AuthResponse?>(null);

  /// ✅ Login dùng hàm tái sử dụng
  Future<void> login(String email, String password) async {
    await execute<AuthResponse>(
      action: () => _loginUseCase(email: email, password: password),
      onSuccess: (data) => user.value = data,
    );
  }

}
 ```        


 # provider
 ```dart

@injectable
class AuthProvider extends BaseProvider {
  AuthProvider(this._loginUseCase);

  final LoginUseCase _loginUseCase;

  AuthResponse? _authData;
  AuthResponse? get authData => _authData;

  /// ✅ Login tái sử dụng từ BaseProvider
  Future<void> login(String email, String password) async {
    await execute<AuthResponse>(
      action: () => _loginUseCase(email: email, password: password),
      onSuccess: (data) {
        _authData = data;
        notifyListeners();
      },
    );
  }
}

 ```    


 # riverpod
 ```dart

final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthResponse?>(AuthNotifier.new);

/// ✅ AuthNotifier kế thừa BaseAsyncNotifier để dùng hàm executeUseCase()
class AuthNotifier extends BaseAsyncNotifier<AuthResponse?> {
  late final LoginUseCase _loginUseCase;

  @override
  FutureOr<AuthResponse?> build() {
    _loginUseCase = getIt<LoginUseCase>();
    return null;
  }

  /// ✅ Login
  Future<void> login(String email, String password) async {
    await execute(
      action: () => _loginUseCase(email: email, password: password),
      onSuccess: (data) => state = AsyncData(data),
    );
  }
}

 ```  



# Usage Example

```dart
class FeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FeatureBloc>()
        ..add(const FetchDataListEvent()),
      child: BlocConsumer<FeatureBloc, BaseState>(
        listener: (context, state) {
          if (state is DataError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is DataLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DataListLoaded<Feature>) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final feature = state.data[index];
                return ListTile(
                  title: Text(feature.name),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```
