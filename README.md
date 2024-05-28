

whatsapp_author is a package for authenticating users using whats app with easy approach .

## Features

- easy to use
- clear structure
- contains error handler
- protected from throwing errors

## Getting started

- add whatsapp_author package to your project by using terminal
```shell
flutter pub add whatsapp_author
```
- create facebook business account and then provide access token , template and phone number for sending auth messages
- create WhatsAppAuthor object 
```dart
WhatsAppAuthor whatsAppAuthor = WhatsAppAuthor(accessToken: accessToken, fromPhoneNumberId: fromPhoneNumberId, templateName: templateName);
```
- then send the verification code using static method [sendCodeToWhatsAppAccount] method
```dart
final String toPhoneNumber = "+00000000";
final String verificationCode = "8468315";
final bool sent = await WhatsAppApiCaller.sendCodeToWhatsAppAccount(author:whatsAppAuthor, code:verificationCode, toPhoneNumber: toPhoneNumber);
 if(sent){
   print("verification code sent successfully");
} else {
   print("error");
}
```

