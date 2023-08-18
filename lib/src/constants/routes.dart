import '../screens/beforeAuth/login.dart';
import '../screens/afterAuth/home.dart';
import '../screens/beforeAuth/register.dart';
import '../screens/afterAuth/profileBuilder.dart';

var routes = {
  '/login': (context) => LoginScreen(),
   '/home': (context) => HomePage(),
  '/register': (context) => RegisterScreen(),
  '/profileBuilder': (context) => ProfileBuilder(),
};
