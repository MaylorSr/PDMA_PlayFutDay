// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/blocs/search/search_bloc.dart';
import 'package:playfutday_flutter/pages/search/search_page.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

import '../blocs/blocs.dart';
import '../pages/pages.dart';

class SearchPost extends SearchDelegate {
  @override
  String? get searchFieldLabel => "Search post by tag";
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = '', icon: Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  late final _blocProvider =
      BlocBuilder<AuthenticationBloc, AuthenticationState>(
    builder: (context, state) {
      if (state is AuthenticationAuthenticated) {
        return BlocProvider(
            create: (_) =>
                SearchBloc(PostService(), query)..add(AllPostFetched()),
            child: AllPostListBySearch(
              user: state.user,
            ));
      } else {
        return const LoginPage();
      }
    },
  );
  @override
  Widget buildResults(BuildContext context) {
    return _blocProvider;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        child: Center(
            child: Icon(
          Icons.do_not_disturb_off_outlined,
          color: Colors.white,
          size: 150,
        )),
      );
    }
    return _blocProvider;
  }
}
