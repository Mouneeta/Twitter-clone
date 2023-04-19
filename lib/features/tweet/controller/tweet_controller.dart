import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/model/tweet_model.dart';

final tweetControllerProvider =
StateNotifierProvider<TweetController, bool>((ref){
  return TweetController(
      ref: ref,
      tweetAPI: ref.watch(tweetAPIProvider),
      storageAPI: ref.watch(storageAPIProvider),
  );
 },
);

final getTweetProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final getLatestTweetProvider = StreamProvider((ref){
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});

class TweetController extends StateNotifier<bool>{
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;
  TweetController({
    required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
  }): _ref = ref ,
      _tweetAPI = tweetAPI,
      _storageAPI = storageAPI,
        super(false);

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return  tweetList.map((tweet) => Tweet.fromMap(tweet.data)) .toList();
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    if(text.isEmpty){
      showSnackBar(context, 'Please enter text');
      return;
  }

    if(images.isNotEmpty){
     _shareImageTweet(
         images: images,
         text: text,
         context: context,
     );
  }  else {
      _shareTextTweet(
          //images: images,
          context: context,
          text: text,
          //repliedTo: '',
          //repliedToUserId: '',
      );
    }

}

  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    })async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks:  imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes:  const [],
      commentIds:  const [],
      id: '',
      reshareCount: 0,
      //retweetedBy: '',
      //repliedTo: '',
    );
    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  Future<void> _shareTextTweet({
    required String text,
    required BuildContext context,
    //required String repliedTo,
    //required String repliedToUserId,
    //required List<File> images,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes:  const [],
      commentIds:  const [],
      id: '',
      reshareCount: 0,
      //retweetedBy: '',
      //repliedTo: '',
    );
  final res = await _tweetAPI.shareTweet(tweet);
  print('push');
  state = false;
  res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  String _getLinkFromText(String text){
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence){
      if(word.startsWith('https://') || word.startsWith('www.')){
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text){
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence){
      if(word.startsWith('#')){
        hashtags.add(word);
      }
    }
    print('push hash');
    return hashtags;
  }


}