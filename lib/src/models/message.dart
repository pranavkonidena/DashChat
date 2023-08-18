import 'package:dash_chat/src/models/user.dart';

class Message {
  MyUser sender;
  List<MyUser> recievers;
  String cipher;
  String messageValue;

  Message(this.sender, this.recievers, this.cipher, this.messageValue);
}
