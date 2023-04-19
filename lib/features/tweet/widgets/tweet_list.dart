import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return ref.watch(getTweetProvider).when(
        data: (tweets) {
          return ref.watch(getLatestTweetProvider).when(
              data: (data) {
                if (data.events.contains(
                  'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                )){
                  tweets.insert(0, Tweet.fromMap(data.payload));
                }
                return ListView.builder(
                   itemCount: tweets.length,
                   itemBuilder: (BuildContext context, int index){
                   final tweet = tweets[index];
                   return TweetCard( tweet: tweet);
              },
          );
              },
              error: (error,stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () {
                return ListView.builder(
                  itemCount: tweets.length,
                  itemBuilder: (BuildContext context, int index){
                    final tweet = tweets[index];
                    return TweetCard( tweet: tweet);
                  },
                );
              }
          );
        },
        error:(error, stackTrace) => ErrorText (
          error: error.toString(),
        ) ,
        loading: () => const Loader(),
    );
  }
}