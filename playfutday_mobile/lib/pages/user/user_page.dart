import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/pages/pages.dart';

import '../../blocs/userProfile/user_profile.dart';
import '../../models/user.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.user});

  final User user;

  @override
  State<UserProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<UserProfilePage> {
  // ignore: unused_field
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        switch (state.status) {
          case UserProfileStatus.failure:
            return Center(
                child: Scaffold(
              appBar: AppBar(title: const Text('Not found the user')),
            ));
          case UserProfileStatus.success:
            return UserScreen(user: state.user, userLoger: widget.user);
          case UserProfileStatus.editProfile:
            return EditProfileScreen(user: state.user!);
          case UserProfileStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
