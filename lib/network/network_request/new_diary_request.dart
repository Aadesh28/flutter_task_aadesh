import 'dart:io';
import 'package:flutter_task_aadesh/network/status_manger.dart';
import 'package:http/http.dart' as http;

class ImageUploadRequest {

 // Thie method will upload the images and make the api request
  Future<ApiResponse> uploadImages(List<File> images) async {

    final request = http.MultipartRequest(
      'POST', Uri.parse('https://api.escuelajs.co/api/v1/files/upload')
    );
    
    try {
      //for loop will add all the images from the list
      for(var image in images) {
        final pic = await http.MultipartFile.fromPath('images', image.path);
        request.files.add(pic);  
      }

      final response = await request.send();

    //If the response is successful
      if(response.statusCode == 200) {
          return ApiResponse.success(Exception('Success response'));         
      } else {
        //if their is an error in the api response
          return ApiResponse.error(Exception('Request failed'));      
          }
    } catch(e) {
      return ApiResponse.error(Exception('Unknown error'));   
      }
    }
}


