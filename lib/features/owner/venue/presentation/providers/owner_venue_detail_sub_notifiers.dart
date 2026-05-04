import 'dart:io';

import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/errors/failures.dart';
import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/repositories/venue_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_venue_detail_sub_notifiers.g.dart';

// ── Amenities ────────────────────────────────────────────────────────────────
@riverpod
class OwnerVenueAmenitiesNotifier extends _$OwnerVenueAmenitiesNotifier
    with BaseNotifier<List<AmenityModel>> {
  late final OwnerVenueRepository _repository;
  late final String _venueId;

  @override
  Future<List<AmenityModel>> build(String venueId) async {
    _repository = getIt<OwnerVenueRepository>();
    _venueId = venueId;
    final result = await _repository.getVenueAmenities(venueId);
    return result.fold(onSuccess: (d) => d, onFailure: (f) => throw f);
  }

  Future<void> _refresh() => runResult(
        action: () => _repository.getVenueAmenities(_venueId),
        mapper: (d) => d,
        keepPreviousOnLoading: true,
      );

  Future<void> addAmenity(String name, [String? icon]) async {
    final result = await _repository.addVenueAmenity(_venueId, name, icon, true);
    if (result.isSuccess) await _refresh();
  }

  Future<void> deleteAmenity(String amenityId) async {
    final result = await _repository.deleteVenueAmenity(_venueId, amenityId);
    if (result.isSuccess) await _refresh();
  }

  Future<void> toggleFree(String amenityId) async {
    final current = currentData?.firstWhere((a) => a.id == amenityId);
    if (current == null) return;
    final result = await _repository.updateVenueAmenity(_venueId, amenityId,
        isFree: !current.isFree);
    if (result.isSuccess) await _refresh();
  }
}

// ── Operating Hours ──────────────────────────────────────────────────────────
@riverpod
class OwnerVenueHoursNotifier extends _$OwnerVenueHoursNotifier
    with BaseNotifier<VenueHoursState> {
  late final OwnerVenueRepository _repository;
  late final String _venueId;

  @override
  Future<VenueHoursState> build(String venueId) async {
    _repository = getIt<OwnerVenueRepository>();
    _venueId = venueId;
    return _fetch();
  }

  Future<VenueHoursState> _fetch() async {
    final results = await Future.wait([
      _repository.getOperatingHours(_venueId),
      _repository.getScheduleExceptions(_venueId),
    ]);
    final hoursRes = results[0] as Result<List<VenueOperatingHoursModel>>;
    final exRes = results[1] as Result<List<VenueScheduleExceptionModel>>;
    if (hoursRes.isFailure) throw hoursRes.failureOrNull ?? const ServerFailure(message: '');
    if (exRes.isFailure) throw exRes.failureOrNull ?? const ServerFailure(message: '');
    return VenueHoursState(
      hours: hoursRes.dataOrNull ?? [],
      exceptions: exRes.dataOrNull ?? [],
    );
  }

  Future<void> _refresh() => runAsync(
        action: _fetch,
        keepPreviousOnLoading: true,
      );

  Future<void> updateHours(List<VenueOperatingHoursModel> hours) async {
    final result = await _repository.updateOperatingHours(_venueId, hours);
    if (result.isSuccess) await _refresh();
  }

  Future<void> addException(VenueScheduleExceptionModel exception) async {
    final result = await _repository.addScheduleException(_venueId, exception);
    if (result.isSuccess) await _refresh();
  }

  Future<void> deleteException(String exceptionId) async {
    final result = await _repository.deleteScheduleException(_venueId, exceptionId);
    if (result.isSuccess) await _refresh();
  }
}

// ── Media ────────────────────────────────────────────────────────────────────
@riverpod
class OwnerVenueMediaNotifier extends _$OwnerVenueMediaNotifier
    with BaseNotifier<VenueMediaState> {
  late final OwnerVenueRepository _repository;
  late final String _venueId;

  @override
  Future<VenueMediaState> build(String venueId) async {
    _repository = getIt<OwnerVenueRepository>();
    _venueId = venueId;
    final result = await _repository.getMediaAttachments(venueId);
    final media = result.fold(onSuccess: (d) => d, onFailure: (f) => throw f);
    return VenueMediaState(media: media);
  }

  Future<void> _refresh() async {
    final result = await _repository.getMediaAttachments(_venueId);
    final current = currentData ?? const VenueMediaState();
    result.fold(
      onSuccess: (d) {
        state = AsyncData(current.copyWith(media: d));
      },
      onFailure: (_) {},
    );
  }

  void pickImages(List<File> files) {
    final current = currentData;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      pendingFiles: [...current.pendingFiles, ...files],
    ));
  }

  void removePending(int index) {
    final current = currentData;
    if (current == null) return;
    final list = List<File>.from(current.pendingFiles);
    list.removeAt(index);
    state = AsyncData(current.copyWith(pendingFiles: list));
  }

  Future<void> savePending() async {
    final current = currentData;
    if (current == null || current.pendingFiles.isEmpty) return;

    try {
      for (final file in current.pendingFiles) {
        final uploadRes = await _repository.uploadFile(file);
        if (uploadRes.isFailure) {
          throw ServerFailure(
              message: uploadRes.failureOrNull?.message ?? 'Lỗi tải ảnh');
        }
        final url = uploadRes.dataOrNull!;
        final addRes = await _repository.addMediaAttachment(_venueId, url);
        if (addRes.isFailure) {
          throw ServerFailure(
              message: addRes.failureOrNull?.message ?? 'Lỗi lưu ảnh');
        }
      }
      state = AsyncData(current.copyWith(pendingFiles: []));
      await _refresh();
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  Future<void> deleteMedia(String mediaId) async {
    final result = await _repository.deleteMediaAttachment(_venueId, mediaId);
    if (result.isSuccess) await _refresh();
  }

  Future<void> setCover(String mediaId) async {
    final result = await _repository.setCoverMedia(_venueId, mediaId);
    if (result.isSuccess) await _refresh();
  }
}

// ── Courts ───────────────────────────────────────────────────────────────────
@riverpod
class OwnerCourtsNotifier extends _$OwnerCourtsNotifier
    with BaseNotifier<List<OwnerCourtModel>> {
  late final OwnerVenueRepository _repository;
  late final String _venueId;

  @override
  Future<List<OwnerCourtModel>> build(String venueId) async {
    _repository = getIt<OwnerVenueRepository>();
    _venueId = venueId;
    final result = await _repository.getVenueCourts(venueId);
    return result.fold(onSuccess: (d) => d, onFailure: (f) => throw f);
  }

  Future<void> _refresh() => runResult(
        action: () => _repository.getVenueCourts(_venueId),
        mapper: (d) => d,
        keepPreviousOnLoading: true,
      );

  Future<void> addCourt(Map<String, dynamic> data) async {
    final result = await _repository.addCourt(_venueId, data);
    if (result.isSuccess) await _refresh();
  }

  Future<void> deleteCourt(String courtId) async {
    final result = await _repository.deleteCourt(_venueId, courtId);
    if (result.isSuccess) await _refresh();
  }
}

// ── Venue Services ───────────────────────────────────────────────────────────
@riverpod
class OwnerVenueServicesNotifier extends _$OwnerVenueServicesNotifier
    with BaseNotifier<List<VenueServiceModel>> {
  late final OwnerVenueRepository _repository;
  late final String _venueId;

  @override
  Future<List<VenueServiceModel>> build(String venueId) async {
    _repository = getIt<OwnerVenueRepository>();
    _venueId = venueId;
    final result = await _repository.getVenueServices(venueId);
    return result.fold(onSuccess: (d) => d, onFailure: (f) => throw f);
  }

  Future<void> _refresh() => runResult(
        action: () => _repository.getVenueServices(_venueId),
        mapper: (d) => d,
        keepPreviousOnLoading: true,
      );

  Future<void> addService(Map<String, dynamic> data) async {
    final result = await _repository.addVenueService(_venueId, data);
    if (result.isSuccess) await _refresh();
  }

  Future<void> updateService(String serviceId, Map<String, dynamic> data) async {
    final result = await _repository.updateVenueService(_venueId, serviceId, data);
    if (result.isSuccess) await _refresh();
  }

  Future<void> deleteService(String serviceId) async {
    final result = await _repository.deleteVenueService(_venueId, serviceId);
    if (result.isSuccess) await _refresh();
  }
}
