import '../../generated/json/base/json_convert_content.dart';

class TokenEntity with JsonConvert<TokenEntity> {
String? accessToken;
int? expiresIn;
}