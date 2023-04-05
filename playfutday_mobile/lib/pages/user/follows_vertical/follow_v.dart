import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/rest/rest.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

import '../../../blocs/userProfile/user_profile_bloc.dart';
import '../../../blocs/userProfile/user_profile_event.dart';
import '../../../services/user_service/user_service.dart';
import '../user_page.dart';

class FollowsScreen extends StatefulWidget {
  final UserFollow userFollow;
  final User user;
  const FollowsScreen({Key? key, required this.userFollow, required this.user})
      : super(key: key);

  @override
  State<FollowsScreen> createState() => _FollowsScreenState();
}

class _FollowsScreenState extends State<FollowsScreen> {
  @override
  Widget build(BuildContext context) {
    final String urlBase = ApiConstants.baseUrl;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (_) => UserProfileBloc(UserService())
                  ..add(UserProfileFetched(widget.userFollow.id.toString())),
                child: UserProfilePage(user: widget.user),
              );
            },
          ),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  maxRadius: 25,
                  child: ClipOval(
                    child: SizedBox(
                      child: CachedNetworkImage(
                        useOldImageOnUrlChange: true,
                        placeholderFadeInDuration: const Duration(seconds: 15),
                        placeholder: (context, url) =>
                            Image.asset('assets/images/reload.gif'),
                        imageUrl:
                            '$urlBase/download/${widget.userFollow.avatar}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/image_notfound.png'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.userFollow.username.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
