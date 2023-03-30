import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/pages/pages.dart';
import '../../../blocs/editProfile/edit_profile.dart';
import '../../../models/user.dart';
import 'edit_profile_page.dart';



class EditProfilePageState extends StatefulWidget {
  const EditProfilePageState({super.key, required this.user});

  final User user;

  @override
  State<EditProfilePageState> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfilePageState> {
  // ignore: unused_field
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (context, state) {
        switch (state.status) {
          case EditProfileStatus.failure:
            return Center(
                child: Scaffold(
              appBar: AppBar(title: const Text('Not change your date!')),
            ));
          case EditProfileStatus.success:
            return EditProfileScreen(user : widget.user);
          case EditProfileStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
