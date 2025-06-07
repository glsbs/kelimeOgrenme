import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class CloudinaryService {
  final String cloudName = 'dhgp2x55w';
  final String uploadPeset = 'flutter_upload_preset';

  Future<String?> uploadImage(File imageFile) async {
    final mimeTypeData = lookupMimeType(imageFile.path)?.split('/');

    if (mimeTypeData == null) {
      return null;
    }

    final imageUploadRequest = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ),
      'upload_preset': uploadPeset,
    });

    try {
      final response = await Dio().post(
        'https://api.cloudinary.com/v1_1/dhgp2x55w/image/upload',
        data: imageUploadRequest,
      );
      print("Dosya yolu: ${imageFile.path}");
      print("MIME tipi: ${lookupMimeType(imageFile.path)}");

      final data = response.data;
      if (data is String) {
        final decoded = jsonDecode(data);
        return decoded['secure_url'];
      } else if (data is Map<String, dynamic>) {
        return data['secure_url'];
      }

      if (response.statusCode == 200) {
        return response.data['secure_url'];
      }
    } catch (e) {
      print("Cloudinary hata:$e");
    }
    return null;
  }
}
