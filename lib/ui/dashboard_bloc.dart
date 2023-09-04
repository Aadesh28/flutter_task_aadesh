import 'dart:async';
import 'dart:io';
import 'package:rxdart/rxdart.dart';

import '../network/network_request/new_diary_request.dart';
import '../network/status_manger.dart';

class DashboardBloc {

ImageUploadRequest serviceCall = ImageUploadRequest();

// This is a `BehaviorSubject` that will emit the response of the API call.
final _responseController = BehaviorSubject<ApiResponse>();

// This getter returns the stream of the response of the API call.
Stream<ApiResponse> get responseStream => _responseController.stream;

// This function makes the API call and emits the response to the `_responseController`.
Future<void> makeRequest(List<File> images) async {
  // 1. Set the initial state of the response to `loading`.
  _responseController.sink.add(ApiResponse.loading(Exception('Loading')));

  // 2. Try to make the API call.
  try {
    await serviceCall.uploadImages(images);

    // 3. If the API call is successful, return a `success` response.
    _responseController.sink.add(ApiResponse.success(Exception('Success')));
  } catch(e) {
    // 4. If the API call fails, return an `error` response.
    _responseController.sink.add(ApiResponse.error(Exception('Request failed')));
  }
}
}