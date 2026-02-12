import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_bloc.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_event.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Events
class FetchUsersEvent extends BaseEvent {}

class UpdateUserEvent extends BaseEvent {
  final String name;
  const UpdateUserEvent(this.name);
}

/// 📘 EXAMPLE: CÁCH SỬ DỤNG BASE BLOC
class UserBloc extends BaseBloc {
  UserBloc() : super(BaseState<List<String>>.initial()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<UpdateUserEvent>(_onUpdateUser);
  }

  // 1️⃣ TRUY VẤN (QUERY)
  Future<void> _onFetchUsers(FetchUsersEvent event, Emitter<BaseState> emit) async {
    await execute<List<String>>(
      emit: emit,
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return const ResultSuccess(['User 1', 'User 2']);
      },
      // Tự động emit Loading hoặc Refreshing
    );
  }

  // 2️⃣ THAY ĐỔI DỮ LIỆU (MUTATION)
  Future<void> _onUpdateUser(UpdateUserEvent event, Emitter<BaseState> emit) async {
    await execute<List<String>>(
      emit: emit,
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return const ResultSuccess(['User 1 Updated']);
      },
      successMessage: 'Cập nhật thành công', // Nhận diện tự động
    );
  }

  // 3️⃣ TRẠNG THÁI TÙY CHỈNH (CUSTOM STATUS)
  Future<void> customExecute(Emitter<BaseState> emit) async {
    await execute<List<String>>(
      emit: emit,
      action: () async {
        return const ResultSuccess(['Custom Data']);
      },
      // Truyền trực tiếp state khởi đầu
      customLoadingState: BaseState.submitting(data: state.data),
    );
  }
}
