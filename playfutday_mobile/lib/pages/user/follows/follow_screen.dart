import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/rest/rest_client.dart';

import '../../../blocs/userProfile/user_profile.dart';
import '../../../services/user_service/user_service.dart';
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
      padding: const EdgeInsets.only(top: 1),
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
            child: CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.grey[300],
              child: ClipOval(
                child: CachedNetworkImage(
                  useOldImageOnUrlChange: true,
                  placeholderFadeInDuration: const Duration(seconds: 15),
                  placeholder: (context, url) =>
                      Image.asset('assets/images/reload.gif'),
                  imageUrl: '$urlBase/download/${widget.userFollow.avatar}',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/image_notfound.png'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            widget.userFollow.username.toString(),
            style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
