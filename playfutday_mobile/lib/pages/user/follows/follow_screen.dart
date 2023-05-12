import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/rest/rest_client.dart';

import '../../../blocs/userProfile/user_profile.dart';
import '../../../services/user_service/user_service.dart';
import '../../../theme/app_theme.dart';
import '../user_page.dart';

class FollowScreen extends StatefulWidget {
  final UserFollow userFollow;
  final User user;

  const FollowScreen({Key? key, required this.userFollow, required this.user})
      : super(key: key);

  @override
  State<FollowScreen> createState() => _FollowAvatarScreenState();
}

class _FollowAvatarScreenState extends State<FollowScreen> {
  final urlBase = ApiConstants.baseUrl;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.minPadding, vertical:AppTheme.minPadding - 5 ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      create: (_) => UserProfileBloc(UserService())
                        ..add(UserProfileFetched(
                            widget.userFollow.id.toString())),
                      child: UserProfilePage(user: widget.user),
                    );
                  },
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: CircleAvatar(
                maxRadius: 25,
                backgroundColor: Colors.grey[300],
                child: ClipOval(
                  child: CachedNetworkImage(
                    placeholderFadeInDuration: const Duration(seconds: 5),
                    placeholder: (context, url) =>
                        Image.asset('assets/images/reload.gif'),
                    imageUrl: '$urlBase/download/${widget.userFollow.avatar}',
                    width: double.infinity,
                    height: 100.0,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/image_notfound.png'),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppTheme.minHeight),
          Container(
            margin: EdgeInsets.only(left: AppTheme.mediumPadding),
            child: Text(
              widget.userFollow.username.toString(),
              style: AppTheme.nameUsersStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
