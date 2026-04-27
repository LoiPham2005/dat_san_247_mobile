import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/base/errors/failures.dart';
import '../../../../../core/base/errors/result.dart';
import '../../../../../core/data/network/api_response.dart';
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

  Future<Result<String>> createGatewayPaymentUrl(String method, String bookingCode) async {
    try {
      final body = {'booking_code': bookingCode};
      late ApiResponse<dynamic> response;
      switch (method) {
        case 'VNPAY':
          response = await _service.createVNPayPayment(body);
          break;
        case 'MOMO':
          response = await _service.createMoMoPayment(body);
          break;
        case 'ZALOPAY':
          response = await _service.createZaloPayPayment(body);
          break;
        default:
          return const ResultFailure(ServerFailure(message: 'Phương thức không hỗ trợ'));
      }
      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final url = data['payment_url'] as String?;
        if (url != null && url.isNotEmpty) return ResultSuccess(url);
      }
      return ResultFailure(ServerFailure(message: response.message ?? 'Không lấy được URL thanh toán'));
    } catch (e) {
      return ResultFailure(_handleError(e));
    }
  }

  Future<Result<String>> getPaymentStatus(String bookingCode) async {
    try {
      final response = await _service.getPaymentStatus(bookingCode);
      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return ResultSuccess(data['payment_status'] as String? ?? 'PENDING');
      }
      return ResultFailure(ServerFailure(message: response.message ?? 'Lỗi kiểm tra trạng thái'));
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
