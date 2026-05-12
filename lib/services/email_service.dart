import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class EmailService {
  // 1. මෙන්න මෙතනට තමයි Service ID එක දාන්න ඕනේ
  static const String serviceId = 'service_jp8zj6c';

  // 2. Email Templates ටැබ් එකෙන් ගත්ත Template ID එක මෙතනට දාන්න
  static const String templateId = 'template_bnoyun9';

  // 3. Account ටැබ් එකේ තියෙන Public Key එක මෙතනට දාන්න
  static const String publicKey = 'Hc4VyAiiwE-odzYlj';

  // OTP එකක් සාදන function එක
  static String generateOTP() {
    return (Random().nextInt(9000) + 1000).toString();
  }

  // Email එක යවන ප්‍රධාන function එක
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