import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageUploadService {
  // Required ImgBB API Key provided by user
  static const String _imgBbApiKey = 'c58199a1a2729edf7a4dece052895137';

  Future<String?> uploadImageBase64(String base64Image) async {
    try {
      // 1. Create the HTTPS URI
      final Uri uri = Uri.parse('https://api.imgbb.com/1/upload');

      // 2. Prepare the POST request with form-urlencoded fields
      final response = await http.post(
        uri,
        body: {
          'key': _imgBbApiKey,
          'image': base64Image,
        },
      );

      // 3. Process the Response
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Success: parse out the hosted CDN URL for the image
          return data['data']['url']; 
        }
      }
      print("ImgBB Upload Failed: ${response.statusCode} - ${response.body}");
      return null;
    } catch (e) {
      print("ImgBB Exception: $e");
      return null;
    }
  }
}
