import 'package:flutter_test/flutter_test.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/auth/view/signup_view.dart';
void main(){
  test('empty email returns error string' , (){
    var result = EmailFieldValidator.validateEmail('');
    expect(result, 'email is required');
  });

  test('non-empty email returns null', (){
    var result = EmailFieldValidator.validateEmail('email');
    expect(result, "");
  });

  test('empty password returns error string' , (){
    var result = PasswordFieldValidator.validatePassword('');
    expect(result, 'password is required');
  });

  test('non-empty password returns null', (){
    var result = PasswordFieldValidator.validatePassword('password');
    expect(result, "");
  });

  test('empty email returns error string' , (){
    var result = SignInEmailValidator.validateEmail('');
    expect(result, 'email is required');
  });

  test('non-empty email returns null', (){
    var result = SignInEmailValidator.validateEmail('email');
    expect(result, "");
  });

  test('empty password returns error string' , (){
    var result = SignInPasswordValidator.validatePassword('');
    expect(result, 'password is required');
  });

  test('non-empty password returns null', (){
    var result = SignInPasswordValidator.validatePassword('password');
    expect(result, "");
  });
}

