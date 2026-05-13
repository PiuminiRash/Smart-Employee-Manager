import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class EmailService {
  static const String serviceId = 'service_jp8zj6c';

  static const String templateId = 'template_bnoyun9';

  static const String publicKey = 'Hc4VyAiiwE-odzYlj';

  static String generateOTP() {
    return (Random().nextInt(9000) + 1000).toString();
  }

  static Future<bool> sendOTP(String email, String name, String otp) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'template_params': {
            'user_name': name,
            'user_email': email,
            'otp_code': otp,
          }
        }),
      );

      if (response.statusCode == 200) {
        print("Email Sent Successfully!");
        return true;
      } else {
        print("Email Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}