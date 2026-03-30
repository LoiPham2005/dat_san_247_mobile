import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../../core/common/constants/api_endpoints.dart';
import '../../../../../core/data/network/api_response.dart';
import '../models/booking_request.dart';


part 'booking_service.g.dart';

@RestApi()
@LazySingleton()
abstract class BookingService {
  @factoryMethod
  factory BookingService(Dio dio) = _BookingService;

  @POST(ApiEndpoints.bookings)
  Future<ApiResponse<CreateBookingResponse>> createBooking(@Body() CreateBookingRequest request);

  @GET(ApiEndpoints.bookingDetail)
  Future<ApiResponse<BookingResponse>> getBookingDetail(@Path('id') String id);

  @DELETE(ApiEndpoints.bookingDetail)
  Future<ApiResponse<void>> cancelBooking(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST('/customer/bookings/{id}/pay')
  Future<ApiResponse<dynamic>> initiatePayment(@Path('id') String id, @Body() Map<String, dynamic> body);

  @GET('/customer/bookings/{id}/payment-status')
  Future<ApiResponse<dynamic>> checkPaymentStatus(@Path('id') String id);

  @GET(ApiEndpoints.myBookings)
  Future<ApiResponse<List<BookingResponse>>> getMyBookings();

  @POST(ApiEndpoints.reviews)
  Future<ApiResponse<void>> submitReview(@Body() ReviewRequest request);

  @POST(ApiEndpoints.uploadReview)
  @MultiPart()
  Future<ApiResponse<FileUploadResponse>> uploadReviewFile(@Part(name: 'file') File file);
}
