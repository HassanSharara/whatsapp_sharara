
import 'dart:convert';
import 'package:whatsapp_author/src/Models/WhatsAppAuthor/whats_app_author.dart';
import 'package:http/http.dart' as http;
class WhatsAppApiCaller {

  static Future<bool>sendCodeToWhatsAppAccount({
    required final WhatsAppAuthor author,
    required final String code,required final String toPhoneNumber,
    final String languageCode = "ar",
    final Function(dynamic)? onApiCallError,
    final Function(http.Response)? onHttpResponse,
  })async{

    final Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization":"Bearer ${author.accessToken}",
    };
    var url = 'https://graph.facebook.com/v14.0/${author.fromPhoneNumberId}/messages';
    Uri uri = Uri.parse(url);

    Map data = {
      "messaging_product": "whatsapp",
      "to": toPhoneNumber,
      "type": "template",
      "template": {
        "name": author.templateName,
        "language": {"code": languageCode},
        "components": [
          {
            "type":"body",
            "parameters":[
              {"type":"text","text":code}
            ]
          },
          {
            "type": "button",
            "sub_type": "url",
            "index": 0,
            "parameters": [
              {
                "type": "text",
                "text": code
              }
            ]
          }
        ]
      }
    };
    final response = await tryFuture(
        http.post(
            uri,body:json.encode(data),
            headers:headers
        ),onError:(e){
      if(onApiCallError!=null)onApiCallError(e);
    });
    if(response==null) return false;
    if(onHttpResponse!=null){
      onHttpResponse(response);
    }
    final Map? body = tryCatch(() =>json.decode(response.body));
    if(body!=null) {
      if(!body.containsKey("messages"))return false;
      final messages = body['messages'];
      if(messages is List) return true;
    }
    return false;
  }


  static Future<T?> tryFuture<T>(Future<T?> future,
      {
        final int? timeoutSeconds,
        final bool withLoading  = false,
        final Function(dynamic er)? onError})async{
    final T? result =  await future.then((value) => value)
        .timeout(Duration(seconds: timeoutSeconds ?? 90))
        .catchError((e){
      if(onError!=null)onError(e);
      return null;
    });
    return result;
  }

  static T? tryCatch<T>(Function() callback, {final Function(dynamic)? onError}){
    try{
      return callback();
    }catch(e){
      if(onError!=null){
        onError(e);
      }
    }
    return null;
  }
}