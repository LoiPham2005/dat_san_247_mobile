import 'package:dat_san_247_mobile/core/state_management/bloc/base_bloc.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/bbbbbbbb_repository.dart';
import 'bbbbbbbb_event.dart';

@injectable
class BbbbbbbbBloc extends BaseBloc {
  final BbbbbbbbRepository _repository;

  BbbbbbbbBloc(this._repository) : super(BaseState.initial()) {
    on<LoadBbbbbbbbs>(_onLoadBbbbbbbbs);
  }

  Future<void> _onLoadBbbbbbbbs(LoadBbbbbbbbs event, Emitter<BaseState> emit) async {
    await execute(
      emit: emit,
      action: () => _repository.getBbbbbbbbs(params: event.params),
    );
  }
}
