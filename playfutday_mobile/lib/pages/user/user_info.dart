import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
        title: Text('${widget.user?.username}'.toUpperCase(),
            style: const TextStyle(
                color: AppTheme.primary,
                fontStyle: FontStyle.italic,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
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
        const SizedBox(height: 5),
        CircleAvatar(
          backgroundColor: Colors.transparent,
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
                      style: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
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
                                  color: Colors.white),
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
                                    builder: (context) => OptionFollowScreen(
                                          id: widget.user!.id.toString(),
                                          username:
                                              widget.user!.username.toString(),
                                          followersView: true,
                                          user: widget.userLoger,
                                        )));
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
                                        color: Colors.white,
                                      ),
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
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
                                    builder: (context) => OptionFollowScreen(
                                          id: widget.user!.id.toString(),
                                          username:
                                              widget.user!.username.toString(),
                                          followersView: false,
                                          user: widget.userLoger,
                                        )));
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
                                        color: Colors.white,
                                      ),
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
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
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    child: Text(state.isFollow ? "Unfollow" : "Follow"),
                                  );
                                },
                              ),
                            ),
                          if (widget.user!.id != widget.userLoger.id)
                            ElevatedButton(
                                onPressed: () {}, child: const Text('messages'))
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
          thickness: 3,
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(start: 22),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  '@${widget.user!.username}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text('${widget.user!.email}',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text('${widget.user!.phone}',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            Row(
              children: [
                widget.user!.birthday == null
                    ? const SizedBox()
                    : const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                const SizedBox(width: 10),
                // ignore: unnecessary_string_interpolations
                Text(
                  widget.user!.birthday ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                widget.user!.biography == null
                    ? const SizedBox()
                    : const Icon(
                        Icons.message_rounded,
                        color: Colors.white,
                      ),
                const SizedBox(width: 10),
                // ignore: unnecessary_string_interpolations
                Expanded(
                  child: Text(
                    widget.user!.biography ?? '',
                    style: const TextStyle(color: Colors.white),
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
                    color: _view == 1 ? Colors.white : Colors.grey,
                    onPressed: () => setState(() => _view = 1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.list),
                    color: _view == 2 ? Colors.white : Colors.grey,
                    onPressed: () => setState(() => _view = 2),
                  ),
                  if ('${widget.user!.username}' ==
                      '${widget.userLoger.username}')
                    IconButton(
                      icon: const Icon(Icons.favorite),
                      color: _view == 3 ? Colors.white : Colors.grey,
                      onPressed: () => setState(() => _view = 3),
                    )
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
                          ? BlocProvider(
                              create: (_) => MyPostBloc(PostService(),
                                  widget.user!.username.toString())
                                ..add(AllPostFetched()),
                              child: _buildListMyPost(),
                            )
                          : BlocProvider(
                              create: (_) => MyFavPostBloc(PostService(),
                                  widget.user!.username.toString())
                                ..add(AllPostFetched()),
                              child: _buildListMyFavPost(),
                            )),
            ],
          ),
        ),
      ]),
    );
  }
}
