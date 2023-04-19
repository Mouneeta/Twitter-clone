

import 'package:flutter_test/flutter_test.dart';
import 'package:twitter_clone/features/auth/view/signup_view.dart';


void main(){
  test('title', (){

  });

  test('empty email returns error string', (){
    var result = EmailFieldValidator.validate('');
    expect(result, 'Email can\t be empty');
  });

  test('non-empty email return null', () {
    var result = EmailFieldValidator.validate('email');
    expect(result, null);
  });

  test('empty password returns error string', (){
    var result = PasswordFieldValidator.validate('');
    expect(result, 'Password can\t be empty');
  });

  test('non-empty password return null', () {
    var result = PasswordFieldValidator.validate('email');
    expect(result, null);
  });

}