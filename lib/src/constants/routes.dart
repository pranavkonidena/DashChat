import '../screens/beforeAuth/login.dart';
import '../screens/afterAuth/home.dart';
import '../screens/beforeAuth/register.dart';
import '../screens/afterAuth/profile_builder.dart';

var routes = {
  '/login': (context) => const LoginScreen(),
  '/home': (context) => const HomePage(),
  '/register': (context) => const RegisterScreen(),
  '/profileBuilder': (context) => const ProfileBuilder(),
};
