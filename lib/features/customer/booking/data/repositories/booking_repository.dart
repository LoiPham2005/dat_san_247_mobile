import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/base/errors/failures.dart';
import '../../../../../core/base/errors/result.dart';
import '../models/booking_request.dart';
import '../services/booking_service.dart';

@lazySingleton
class BookingRepository {
  final BookingService _service;

  BookingRepository(this._service);

  Future<Result<BookingResponse>> createBooking(CreateBookingRequest request) async {
    try {
      final response = await _service.createBooking(request);
      if (response.isSuccess && response.data != null) {
        final booking = response.data!.bookings.first;
        return ResultSuccess(booking);
      }
      return ResultFailure(ServerFailure(
        message: response.message ?? 'Lỗi không xác định',
        statusCode: response.statusCode,
      ));
    } catch (e) {
      return ResultFailure(_handleError(e));
    }
  }

  Future<Result<BookingResponse>> getBookingDetail(String id) async {
    try {
      final response = await _service.getBookingDetail(id);
      if (response.isSuccess && response.data != null) {
        return ResultSuccess(response.data!);
      }
      return ResultFailure(ServerFailure(
        message: response.message ?? 'Lỗi không xác định',
        statusCode: response.statusCode,
      ));
    } catch (e) {
      return ResultFailure(_handleError(e));
    }
  }

  Future<Result<Map<String, dynamic>>> initiatePayment(String id, String method) async {
    try {
      final response = await _service.initiatePayment(id, {'method': method});
      if (response.isSuccess && response.data != null) {
        return ResultSuccess(response.data as Map<String, dynamic>);
      }
      return ResultFailure(ServerFailure(
        message: response.message ?? 'Lỗi không xác định',
        statusCode: response.statusCode,
      ));
    } catch (e) {
      return ResultFailure(_handleError(e));
    }
  }

  Future<Result<Map<String, dynamic>>> checkPaymentStatus(String id) async {
    try {
      final response = await _service.checkPaymentStatus(id);
      if (response.isSuccess && response.data != null) {
        return ResultSuccess(response.data as Map<String, dynamic>);
      }
      return ResultFailure(ServerFailure(
        message: response.message ?? 'Lỗi không xác định',
        statusCode: response.statusCode,
      ));
    } catch (e) {
      return ResultFailure(_handleError(e));
    }
  }

  Future<Result<void>> cancelBooking(String id, String reason) async {
    try {
      final response = await _service.cancelBooking(id, {'reason': reason});
      if (response.isSuccess) {
        return const ResultSuccess(null);
      }
      return ResultFailure(ServerFailure(message: response.message ?? 'Hủy không thành công'));
    } catch (e) {
      return ResultFailure(_handleError(e));
    }
  }

  Future<Result<List<BookingResponse>>> getMyBookings() async {
    try {
      final response = await _service.getMyBookings();
      if (response.isSuccess && response.data != null) {
        return ResultSuccess(response.data!);
      }
      return ResultFailure(ServerFailure(
        message: response.message ?? 'Lỗi không xác định',
        statusCode: response.statusCode,
      ));
    } catch (e) {
      return ResultFailure(_handleError(e));
    }
  }

  Future<Result<void>> submitReview(ReviewRequest request) async {
    try {
      final response = await _service.submitReview(request);
      if (response.isSuccess) {
        return const ResultSuccess(null);
      }
      return ResultFailure(ServerFailure(message: response.message ?? 'Gửi đánh giá không thành công'));
    } catch (e) {
      return ResultFailure(_handleError(e));
    }
  }

  Future<Result<String>> uploadReviewFile(File file) async {
    try {
      final response = await _service.uploadReviewFile(file);
      if (response.isSuccess && response.data != null) {
        return ResultSuccess(response.data!.url);
      }
      return ResultFailure(ServerFailure(message: response.message ?? 'Tải lên tệp không thành công'));
    } catch (e) {
      return ResultFailure(_handleError(e));
    }
  }

  Failure _handleError(Object e) {
    if (e is DioException) {
      final responseData = e.response?.data;
      if (responseData is Map && responseData.containsKey('message')) {
        return ServerFailure(
          message: responseData['message'].toString(),
          statusCode: e.response?.statusCode,
        );
      }
      return ServerFailure(
        message: e.message ?? e.toString(),
        statusCode: e.response?.statusCode,
      );
    }
    return ServerFailure(message: e.toString());
  }
}
