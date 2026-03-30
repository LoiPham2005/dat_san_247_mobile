import 'dart:io';
import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/repositories/venue_repository.dart';
import 'package:injectable/injectable.dart';

// ── Amenities Cubit ──────────────────────────────────────────────────────────
@injectable
class OwnerVenueAmenitiesCubit extends BaseCubit<List<AmenityModel>> {
  final OwnerVenueRepository _repository;
  OwnerVenueAmenitiesCubit(this._repository) : super(BaseState.initial());

  Future<void> fetchAmenities(String venueId) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.getVenueAmenities(venueId);
    if (isClosed) return;
    result.fold(
      onSuccess: (data) => emit(BaseState.success(data: data)),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> addAmenity(String venueId, String name, [String? icon]) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.addVenueAmenity(venueId, name, icon, true);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => fetchAmenities(venueId), // Refresh
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> deleteAmenity(String venueId, String amenityId) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.deleteVenueAmenity(venueId, amenityId);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => fetchAmenities(venueId), // Refresh
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> toggleFree(String venueId, String amenityId) async {
    final current = state.data?.firstWhere((a) => a.id == amenityId);
    if (current == null) return;

    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.updateVenueAmenity(venueId, amenityId, isFree: !current.isFree);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => fetchAmenities(venueId), // Refresh
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }
}

// ── Operating Hours Cubit ────────────────────────────────────────────────────
@injectable
class OwnerVenueHoursCubit extends BaseCubit<VenueHoursState> {
  final OwnerVenueRepository _repository;
  OwnerVenueHoursCubit(this._repository) : super(const BaseState(status: BaseStatus.initial, data: VenueHoursState()));

  Future<void> fetchHours(String venueId) async {
    emit(BaseState.loading(previousData: state.data));
    
    final results = await Future.wait([
      _repository.getOperatingHours(venueId),
      _repository.getScheduleExceptions(venueId),
    ]);

    if (isClosed) return;

    final hoursRes = results[0] as Result<List<VenueOperatingHoursModel>>;
    final exRes = results[1] as Result<List<VenueScheduleExceptionModel>>;

    if (hoursRes.isSuccess && exRes.isSuccess) {
      emit(BaseState.success(data: VenueHoursState(
        hours: hoursRes.dataOrNull ?? [],
        exceptions: exRes.dataOrNull ?? [],
      )));
    } else {
      final error = hoursRes.failureOrNull?.message ?? exRes.failureOrNull?.message ?? 'Lỗi tải dữ liệu giờ';
      emit(BaseState.failure(error: error, previousData: state.data));
    }
  }

  Future<void> updateHours(String venueId, List<VenueOperatingHoursModel> hours) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.updateOperatingHours(venueId, hours);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => fetchHours(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> addException(String venueId, VenueScheduleExceptionModel exception) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.addScheduleException(venueId, exception);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => fetchHours(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> deleteException(String venueId, String exceptionId) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.deleteScheduleException(venueId, exceptionId);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => fetchHours(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }
}

// ── Media Cubit ──────────────────────────────────────────────────────────────
@injectable
class OwnerVenueMediaCubit extends BaseCubit<VenueMediaState> {
  final OwnerVenueRepository _repository;
  OwnerVenueMediaCubit(this._repository) : super(const BaseState(status: BaseStatus.initial, data: VenueMediaState()));

  Future<void> fetchMedia(String venueId) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.getMediaAttachments(venueId);
    if (isClosed) return;
    result.fold(
      onSuccess: (data) => emit(BaseState.success(data: state.data!.copyWith(media: data))),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  void pickImages(List<File> files) {
    emit(BaseState.success(data: state.data!.copyWith(
      pendingFiles: [...state.data!.pendingFiles, ...files],
    )));
  }

  void removePending(int index) {
    final list = List<File>.from(state.data!.pendingFiles);
    list.removeAt(index);
    emit(BaseState.success(data: state.data!.copyWith(pendingFiles: list)));
  }

  Future<void> savePending(String venueId) async {
    if (state.data!.pendingFiles.isEmpty) return;
    emit(BaseState.loading(previousData: state.data));

    try {
      for (final file in state.data!.pendingFiles) {
        // 1. Upload
        final uploadRes = await _repository.uploadFile(file);
        if (uploadRes.isFailure) throw Exception(uploadRes.failureOrNull?.message ?? 'Lỗi tải ảnh');
        
        final url = uploadRes.dataOrNull!;
        
        // 2. Add to DB
        final addRes = await _repository.addMediaAttachment(venueId, url);
        if (addRes.isFailure) throw Exception(addRes.failureOrNull?.message ?? 'Lỗi lưu thông tin ảnh');
      }

      // Clear pending and refresh
      emit(BaseState.success(data: state.data!.copyWith(pendingFiles: [])));
      fetchMedia(venueId);
    } catch (e) {
      emit(BaseState.failure(error: e.toString(), previousData: state.data));
    }
  }

  Future<void> deleteMedia(String venueId, String mediaId) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.deleteMediaAttachment(venueId, mediaId);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => fetchMedia(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> setCover(String venueId, String mediaId) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.setCoverMedia(venueId, mediaId);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => fetchMedia(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }
}

// ── Courts Cubit ─────────────────────────────────────────────────────────────
@injectable
class OwnerCourtsCubit extends BaseCubit<List<OwnerCourtModel>> {
  final OwnerVenueRepository _repository;
  OwnerCourtsCubit(this._repository) : super(BaseState.initial());

  Future<void> fetchCourts(String venueId) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.getVenueCourts(venueId);
    if (isClosed) return;
    result.fold(
      onSuccess: (data) => emit(BaseState.success(data: data)),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> addCourt(String venueId, Map<String, dynamic> data) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.addCourt(venueId, data);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => fetchCourts(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> deleteCourt(String venueId, String courtId) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.deleteCourt(venueId, courtId);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => fetchCourts(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }
}

// ── Venue Services Cubit ─────────────────────────────────────────────────────
@injectable
class OwnerVenueServicesCubit extends BaseCubit<List<VenueServiceModel>> {
  final OwnerVenueRepository _repository;
  OwnerVenueServicesCubit(this._repository) : super(BaseState.initial());

  Future<void> fetchServices(String venueId) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.getVenueServices(venueId);
    if (isClosed) return;
    result.fold(
      onSuccess: (data) => emit(BaseState.success(data: data)),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> addService(String venueId, Map<String, dynamic> data) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.addVenueService(venueId, data);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => fetchServices(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> updateService(String venueId, String serviceId, Map<String, dynamic> data) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.updateVenueService(venueId, serviceId, data);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => fetchServices(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> deleteService(String venueId, String serviceId) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.deleteVenueService(venueId, serviceId);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => fetchServices(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }
}
