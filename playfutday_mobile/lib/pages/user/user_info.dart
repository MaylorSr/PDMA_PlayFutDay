import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:playfutday_flutter/blocs/follows/follow.dart';
import 'package:playfutday_flutter/blocs/post_grid_user/post_grid_event.dart';
import 'package:playfutday_flutter/blocs/userProfile/user_profile.dart';
import 'package:playfutday_flutter/models/infoUser.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/pages/user/post_user.dart';
import 'package:playfutday_flutter/pages/user/post_view_grid_user/post_grid_view.dart';
import 'package:playfutday_flutter/rest/rest.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';
import 'package:readmore/readmore.dart';

import '../../blocs/blocs.dart';
import '../../blocs/cubit/button_follow_cubit.dart';
import '../../blocs/followers/followers.dart';
import '../../blocs/myFavPost/my_fav_Post_bloc.dart';
import '../../blocs/postUser/post_user_bloc.dart';
import '../../blocs/post_grid_user/post_grid_bloc.dart';
import '../../theme/app_theme.dart';
import '../post/myFavPost/post_pageFav.dart';
import 'option_follow.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key, this.user, required this.userLoger})
      : super(key: key);

  final UserInfo? user;
  final User userLoger;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final String urlBase = ApiConstants.baseUrl;
  final UserService userService = UserService();
  int _view = 1; // variable para cambiar la vista entre grid y lista

  BlocProvider _buildListMyPost() {
    // lista de widgets para la vista de lista

    return BlocProvider(
        create: (_) =>
            MyPostBloc(PostService(), widget.user!.username.toString())
              ..add(AllPostFetched()),
        child: MyPostList(
          user: widget.userLoger,
        ));
  }

  BlocProvider _buildListMyFavPost() {
    // lista de widgets para la vista de lista
    return BlocProvider(
        create: (_) =>
            MyFavPostBloc(PostService(), widget.user!.username.toString())
              ..add(AllPostFetched()),
        child: MyFavPostList(
          user: widget.userLoger,
        ));
  }

  Future<int> _getTotalElements() async {
    final followerBloc =
        FollowerBloc(UserService(), widget.user!.id.toString());
    final totalElements = await followerBloc.getTotalElements();
    return totalElements;
  }

  Future<int> _getTotalElementsFollows() async {
    final followBloc = FollowBloc(UserService(), widget.user!.id.toString());
    final totalElements = await followBloc.getTotalElements();
    return totalElements;
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    final contextProfile = context;

    return Scaffold(
      appBar: AppBar(
        leading: widget.user!.id != widget.userLoger.id
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                    Platform.isAndroid
                        ? Icons.arrow_back_rounded
                        : Icons.arrow_back_ios_new_rounded,
                    size: 25),
              )
            : null,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '${widget.user?.username}'.toUpperCase(),
          style: AppTheme.tittleApp,
        ),
        actions: [
          if (widget.user!.id == widget.userLoger.id)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor:
                                const Color.fromARGB(255, 83, 83, 83),
                            context: contextProfile,
                            builder: (contextProfile) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                      minLeadingWidth: 5,
                                      leading: const Icon(Icons.edit_outlined),
                                      title: const Text('Edit Profile'),
                                      onTap: () {
                                        BlocProvider.of<UserProfileBloc>(
                                                context)
                                            .add(EditProfileState());
                                        Navigator.pop(context);
                                      }),
                                  const Divider(
                                    color: AppTheme.primary,
                                    indent: 20,
                                    endIndent: 20,
                                    thickness: 1,
                                  ),
                                  ListTile(
                                      minLeadingWidth: 5,
                                      leading: Icon(Platform.isAndroid
                                          ? Icons.close
                                          : Icons
                                              .remove_circle_outline_outlined),
                                      title: const Text('Delete my account'),
                                      onTap: () {
                                        EasyLoading.showInfo(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            "You account was delete");
                                        Future.delayed(const Duration(
                                                milliseconds: 800))
                                            .then((value) => {
                                                  userService.deleteUserOrMe(
                                                      widget.userLoger.id
                                                          .toString()),
                                                  authBloc.add(UserLoggedOut()),
                                                  Navigator.pop(context)
                                                });
                                      }),
                                  const Divider(
                                    color: AppTheme.primary,
                                    indent: 20,
                                    endIndent: 20,
                                    thickness: 1,
                                  ),
                                  ListTile(
                                    minLeadingWidth: 5,
                                    leading: Icon(Platform.isAndroid
                                        ? Icons.logout
                                        : Icons.logout_outlined),
                                    title: const Text('Logout'),
                                    onTap: () {
                                      EasyLoading.show(status: 'Logout...');
                                      Future.delayed(
                                          const Duration(milliseconds: 650),
                                          () {
                                        EasyLoading.dismiss(animation: true)
                                            .then((value) => {
                                                  authBloc.add(UserLoggedOut()),
                                                  Navigator.pop(context)
                                                });
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.menu, size: 30)),
                ],
              ),
            ),
        ],
      ),
      body: Column(children: [
        SizedBox(height: AppTheme.minHeight),
        Hero(
          tag: widget.user!.id.toString(),
          child: CircleAvatar(
            backgroundColor: AppTheme.transparent,
            maxRadius: 40,
            child: ClipOval(
              child: CachedNetworkImage(
                placeholderFadeInDuration: const Duration(seconds: 5),
                placeholder: (context, url) =>
                    Image.asset('assets/images/reload.gif'),
                imageUrl: '$urlBase/download/${widget.user!.avatar}',
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/avatar.png'),
                width: double.infinity,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      '@${widget.user!.username}',
                      style: AppTheme.nameUsersStyle.copyWith(fontSize: 17),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.user?.myPost == null ? 0 : widget.user!.myPost!.length}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppTheme.primary),
                            ),
                            const SizedBox(height: 5),
                            const Icon(
                              Icons.photo_library_outlined,
                              size: 25,
                            )
                          ],
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FadeInRight(
                                  duration: const Duration(milliseconds: 500),
                                  child: OptionFollowScreen(
                                    id: widget.user!.id.toString(),
                                    username: widget.user!.username.toString(),
                                    followersView: true,
                                    user: widget.userLoger,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              FutureBuilder(
                                future: _getTotalElements(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: AppTheme.primary,
                                      ),
                                    );
                                  } else {
                                    return LoadingAnimationWidget
                                        .twoRotatingArc(
                                            color: const Color.fromARGB(
                                                255, 6, 49, 122),
                                            size: 45);
                                  }
                                },
                              ),
                              const SizedBox(height: 5),
                              const Icon(
                                Icons.people_alt_rounded,
                                size: 25,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FadeInRight(
                                  duration: const Duration(milliseconds: 500),
                                  child: OptionFollowScreen(
                                    id: widget.user!.id.toString(),
                                    username: widget.user!.username.toString(),
                                    followersView: false,
                                    user: widget.userLoger,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              FutureBuilder(
                                future: _getTotalElementsFollows(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: AppTheme.primary,
                                      ),
                                    );
                                  } else {
                                    return LoadingAnimationWidget.dotsTriangle(
                                        color: const Color.fromARGB(
                                            255, 6, 49, 122),
                                        size: 45);
                                  }
                                },
                              ),
                              const SizedBox(height: 5),
                              const Icon(
                                Icons.people_outline_outlined,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (widget.user!.id != widget.userLoger.id)
                            BlocProvider(
                              create: (context) => ButtonFollowCubit(
                                  widget.user!.id.toString(), UserService())
                                ..showFollowState(),
                              child: BlocBuilder<ButtonFollowCubit,
                                  ButtonFollowInitial>(
                                builder: (context, state) {
                                  return ElevatedButton(
                                    onPressed: () =>
                                        BlocProvider.of<ButtonFollowCubit>(
                                            context)
                                          ..addFollow(),
                                    child: Text(
                                        style: AppTheme.nameUsersStyle
                                            .copyWith(fontSize: 14),
                                        state.isFollow ? "Unfollow" : "Follow"),
                                  );
                                },
                              ),
                            ),
                          if (widget.user!.id != widget.userLoger.id)
                            ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                    style: AppTheme.nameUsersStyle
                                        .copyWith(fontSize: 14),
                                    'messages'))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ],
        ),
        const Divider(
          color: AppTheme.primary,
          thickness: 0.5,
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(start: 22),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const Icon(Icons.person, color: AppTheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '@${widget.user!.username}',
                    style: AppTheme.nameUsersStyle
                        .copyWith(color: AppTheme.primary, fontSize: 16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.email,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    '${widget.user!.email}',
                    style: AppTheme.nameUsersStyle
                        .copyWith(color: AppTheme.primary, fontSize: 16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.phone,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  '${widget.user!.phone}',
                  style: AppTheme.nameUsersStyle
                      .copyWith(color: AppTheme.primary, fontSize: 16),
                ),
              ],
            ),
            if (widget.user!.birthday != null)
              Row(
                children: [
                  widget.user!.birthday == null
                      ? const SizedBox()
                      : const Icon(
                          Icons.calendar_month,
                          color: AppTheme.primary,
                        ),
                  const SizedBox(width: 10),
                  // ignore: unnecessary_string_interpolations
                  Text(
                    widget.user!.birthday ?? '',
                    style: AppTheme.nameUsersStyle
                        .copyWith(color: AppTheme.primary, fontSize: 16),
                  ),
                ],
              ),
            Row(
              children: [
                widget.user!.biography == null
                    ? const SizedBox()
                    : const Icon(
                        Icons.message_rounded,
                        color: AppTheme.primary,
                      ),
                const SizedBox(width: 10),
                // ignore: unnecessary_string_interpolations
                Expanded(
                  child: ReadMoreText(
                    delimiter: "...",
                    trimLength: 60,
                    colorClickableText: AppTheme.grey.withBlue(10),
                    delimiterStyle: AppTheme.tittleApp.copyWith(
                        fontSize: 15,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600),
                    trimCollapsedText: " read more.",
                    trimExpandedText: " show less.",
                    widget.user!.biography ?? '',
                    style: AppTheme.nameUsersStyle
                        .copyWith(color: AppTheme.primary, fontSize: 14),
                  ),
                ),
              ],
            ),
          ]),
        ),
        const Divider(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.grid_on),
                    color: _view == 1 ? AppTheme.primary : AppTheme.grey,
                    onPressed: () => setState(() => _view = 1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.list),
                    color: _view == 2 ? AppTheme.primary : AppTheme.grey,
                    onPressed: () {
                      setState(() {
                        _view == 1;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FadeInUpBig(
                              duration: const Duration(milliseconds: 300),
                              child: AllPostScreenUser(
                                blocPost: _buildListMyPost(),
                                user: widget.user!,
                                isFav: true,
                                userLogger: widget.userLoger,
                              ),
                            ),
                          ),
                        );
                      });
                    },
                    // onPressed: ()  {setState(() => _view = 2}),),
                  ),
                  if ('${widget.user!.username}' ==
                      '${widget.userLoger.username}')
                    IconButton(
                        icon: const Icon(Icons.favorite),
                        color: _view == 3 ? AppTheme.primary : AppTheme.grey,
                        onPressed: () {
                          setState(() {
                            _view = 1;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FadeInUpBig(
                                  duration: const Duration(milliseconds: 300),
                                  child: AllPostScreenUser(
                                    blocPost: _buildListMyFavPost(),
                                    user: widget.user!,
                                    isFav: false,
                                    userLogger: widget.userLoger,
                                  ),
                                ),
                              ),
                            );
                          });
                        })
                ],
              ),
              // vista de grid o lista según la variable _isGridView
              Expanded(
                  child: _view == 1
                      ? BlocProvider(
                          create: (_) => AllImagePostGridBloc(
                              PostService(), widget.user!.username.toString())
                            ..add(AllImagePostGridFetched()),
                          child: const PostGridImageScreen(),
                        )
                      : _view == 2
                          ? const SizedBox()
                          : const SizedBox()
                  // : BlocProvider(
                  //     create: (_) => MyFavPostBloc(
                  //         PostService(), widget.user!.username.toString())
                  //       ..add(AllPostFetched()),
                  //     child: _buildListMyFavPost(),
                  //   ),
                  ),
            ],
          ),
        ),
      ]),
    );
  }
}

class AllPostScreenUser extends StatelessWidget {
  final UserInfo user;
  final User userLogger;
  final bool isFav;
  final BlocProvider blocPost;
  const AllPostScreenUser(
      {super.key,
      required this.blocPost,
      required this.user,
      required this.userLogger,
      required this.isFav});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: user.id != userLogger.id
                ? IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                        Platform.isAndroid
                            ? Icons.arrow_back_rounded
                            : Icons.arrow_back_ios_new_rounded,
                        size: 25),
                  )
                : null,
            elevation: 0,
            centerTitle: true,
            title: Text(
              '${user.username}'.toUpperCase(),
            )),
        body: isFav
            ? BlocProvider(
                create: (_) =>
                    MyPostBloc(PostService(), user.username.toString())
                      ..add(AllPostFetched()),
                child: blocPost)
            : BlocProvider(
                create: (_) =>
                    MyFavPostBloc(PostService(), user.username.toString())
                      ..add(AllPostFetched()),
                child: blocPost)
        // body: BlocProvider(
        //   create: (context) => isFav ?
        //               MyFavPostBloc(PostService(),  user.username.toString())..add(AllPostFetched()), child: blocPost :
        //   MyPostBloc(PostService(), user.username.toString())
        //     ..add(AllPostFetched()),
        //   child: blocPost,
        // ),
        );
  }
}
