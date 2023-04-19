import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/model/user_model.dart';
import '../../../apis/auth_api.dart';
import '../../home/view/home_view.dart';
import '../view/login_view.dart';
import 'package:appwrite/models.dart' as model;

final authControllerProvider =
 StateNotifierProvider<AuthController, bool>((ref) {
   return AuthController(
     authAPI: ref.watch(authAPIProvider),
     userAPI: ref.watch(userAPIProvider),
   );
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool>{
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  }) : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  //state isLoading


  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

 void signUp({
   required String email,
   required String password,
   required BuildContext context,
   }) async {
   state = true;
   final res = await _authAPI.signUp(
     email: email,
     password: password,
   );
   state = false;
   res.fold((l) => showSnackBar(context, l.message),
         (r) async {
       UserModel userModel = UserModel(email: email,
         name: getNameFromeEmail(email),
         followers: const [],
         following: const [],
         profilePic: '',
         bannerPic: '',
         uid: r.$id,
         bio: '',
         isTwitterBlue: false,
       );
       final res2 = await _userAPI.saveUserData(userModel);
       res2.fold((l) => showSnackBar(context, l.message), (r) {
         showSnackBar(context, 'Account created! Please login.');
         Navigator.push(context, LoginView.route());
       });
     },
   );
 }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l) => showSnackBar(context, l.message),
          (r) {
            //showSnackBar(context, 'Account created! Please login.');
            Navigator.push(context, HomeView.route());
          },
    );
  }

  Future<UserModel> getUserData(String uid) async {
   final document = await _userAPI.getUserData(uid);
   final updateUser = UserModel.fromMap(document.data);
   return updateUser;
  }
}