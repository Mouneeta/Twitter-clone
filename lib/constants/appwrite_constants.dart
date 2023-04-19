class AppwriteConstants {
  static const String databaseId = "64267ffbe5835793e9c1";
  static const String projectId = "642673200ee936007c14";
  //static const String endPoint = "http://172.18.104.74:80/v1";
  static const String endPoint = "http://172.18.104.64/v1";
  //static const String endPoint = "http://localhost:80/v1";

  static const String userCollection = '642bfbb1dd53addd11ae';
  static const String tweetsCollection = '64366996b7fdb8bcdcc6';
  static const String imagesBucket = '64365dcfbe36c7e67641';

  static String imageUrl(String imageId) => '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
} 