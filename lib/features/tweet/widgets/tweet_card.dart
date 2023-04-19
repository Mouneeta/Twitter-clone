import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:any_link_preview/any_link_preview.dart';
class TweetCard extends ConsumerWidget {
  final Tweet tweet;

  const TweetCard({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(tweet.uid)).when(
      data: (user) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                      radius: 35,
                  ),
                ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //reterrt
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                        ),
                      ),
                      Text(
                        '@${user.name} .${timeago.format(
                          tweet.tweetedAt,
                          locale: 'en_short',
                        )}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Pallete.greyColor,
                        ),
                      ),
                    ],
                  ),
                  ///replied to
                  HashtagText(text: tweet.text),
                  if(tweet.tweetType == TweetType.image)
                    CarouselImage(imageLinks: tweet.imageLinks),
                  if (tweet.link.isNotEmpty) ...[
                    const SizedBox(height: 4,),
                    AnyLinkPreview(
                      displayDirection: UIDirection.uiDirectionHorizontal,
                        link: 'https://${tweet.link}',
                    ),
                  ],
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TweetIconButton(
                            text: (
                                tweet.commentIds.length+
                                tweet.reshareCount+
                                tweet.likes.length
                            ).toString(),
                            pathName: AssetsConstants.viewsIcon,
                            onTap: () {},
                        ),
                        TweetIconButton(
                          text: tweet.commentIds.length.toString(),
                          pathName: AssetsConstants.commentIcon,
                          onTap: () {},
                        ),
                        TweetIconButton(
                          text: tweet.reshareCount.toString(),
                          pathName: AssetsConstants.retweetIcon,
                          onTap: () {},
                        ),
                        TweetIconButton(
                          text: tweet.likes.length.toString(),
                          pathName: AssetsConstants.likeOutlinedIcon,
                          onTap: () {},
                        ),
                        IconButton(onPressed: () {} ,
                            icon: const Icon(
                              Icons.share_outlined,
                              size: 25,
                              color: Pallete.greyColor,
                            ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 1),
                ],),
            ),
        ],
            ),
            const Divider(color: Pallete.greyColor,),
          ],
        );
      },
      error:(error, stackTrace) => ErrorText (error: error.toString(),) ,
      loading: () => const Loader(),);
  }
}