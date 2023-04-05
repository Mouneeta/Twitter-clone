import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';

import '../model/user_model.dart';

final userAPIProvider = Provider((ref){
  return UserAPI(db: ref.watch(appwriteDatebaseProvider));
});


abstract class IUserApi{
  FutureEitherVoid saveUserData(UserModel userModel);
}

class UserAPI implements IUserApi{
  final Databases _db;
  UserAPI ({ required Databases db}): _db = db;
  @override
  FutureEitherVoid saveUserData(UserModel userModel)
  async {
    try {
        await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId:AppwriteConstants.userCollection,
        documentId: ID.unique(),
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
          Failure(
              e.message?? 'some unexpected error occured',
              st,
          ),
      );
    } catch (e,st) {
      return left(Failure(e.toString(),st,),);
    }
  }
}