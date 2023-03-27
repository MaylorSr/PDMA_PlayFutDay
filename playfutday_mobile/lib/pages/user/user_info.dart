import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/models/infoUser.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/pages/pages.dart';
import 'package:playfutday_flutter/pages/user/post_user.dart';
import 'package:playfutday_flutter/rest/rest.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';

import '../../blocs/blocs.dart';
import '../../blocs/editProfile/edit_profile.dart';
import '../../blocs/myFavPost/my_fav_Post_bloc.dart';
import '../../blocs/postUser/post_user_bloc.dart';
import '../../theme/app_theme.dart';
import '../post/myFavPost/post_pageFav.dart';
import 'editProfile/edit_profile_page.dart';

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

  List<Widget> _buildGridMyPost() {
    // lista de widgets para la vista de grid
    if (widget.user!.myPost != null) {
      // '${urlBase}/download/${widget.user!.myPost![index].image}'
      // agregando una validación aquí
      return List.generate(
          widget.user!.myPost!.length,
          (index) => FadeInLeft(
                animate: true,
                duration: const Duration(seconds: 2),
                child: SizedBox(
                  height: 300,
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.network(
                      '$urlBase/download/${widget.user!.myPost![index].image}',
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/images/image_notfound.png'),
                    ),
                  ),
                ),
              ));
    } else {
      return []; // devolver una lista vacía si widget.user.myPost es nulo
    }
  }

  // // ignore: unused_element
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

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text('PlayFutDay',
              style: TextStyle(
                  color: AppTheme.primary,
                  fontStyle: FontStyle.italic,
                  fontSize: 25,
                  fontWeight: FontWeight.w600))),
      body: Column(children: [
        const SizedBox(height: 2),
        if (widget.user!.id == widget.userLoger.id)
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return FadeInLeft(
                              animate: true,
                              delay: const Duration(seconds: 1),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading:
                                        const Icon(Icons.mode_edit_outlined),
                                    title: const Text('Edit Profile'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MultiBlocProvider(
                                            providers: [
                                              BlocProvider<EditProfileBloc>(
                                                create: (_) => EditProfileBloc(
                                                    UserService())
                                                  ..add(EditProfileFetched(
                                                      widget.userLoger)),
                                              ),
                                            ],
                                            child: EditProfilePageState(
                                              user: widget.userLoger,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Platform.isAndroid
                                        ? Icons.close
                                        : Icons.remove_circle_outline_outlined),
                                    title: const Text('Delete my account'),
                                    onTap: () {
                                      userService.deleteUserOrMe(
                                          widget.userLoger.id.toString());
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Platform.isAndroid
                                        ? Icons.logout
                                        : Icons.logout_outlined),
                                    title: const Text('Logout'),
                                    onTap: () {
                                      authBloc.add(UserLoggedOut());
                                      Navigator.pop(
                                          context); // Cerrar la hoja de opciones
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.menu, size: 40)),
              ],
            ),
          ),
        CircleAvatar(
          maxRadius: 50,
          child: ClipOval(
            child: Image.network(
              '$urlBase/download/${widget.user!.avatar}',
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/images/image_notfound.png'),
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(
              width: 16,
              height: 20,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      '@${widget.user!.username}',
                      style: const TextStyle(
                          fontSize: 25,
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
                        Column(
                          children: const [
                            Text(
                              '0',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 5),
                            Icon(
                              Icons.people_alt_rounded,
                              size: 25,
                            )
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: const [
                            Text(
                              '0',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 5),
                            Icon(
                              Icons.people_outline_outlined,
                              size: 25,
                            )
                          ],
                        ),
                      ],
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
          child: Column(children: [
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
                Text(
                  widget.user!.biography ?? '',
                  style: const TextStyle(color: Colors.white),
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
              // botones para cambiar la vista entre grid y lista
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.grid_on),
                    color: _view == 1 ? Colors.white : Colors.grey,
                    onPressed: () => setState(() => _view = 1),
                  ),
                  IconButton(
                    icon: Icon(Icons.list),
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
                      ? GridView.count(
                          crossAxisCount: 2,
                          children: _buildGridMyPost(),
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
