import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:playfutday_flutter/rest/rest.dart';

import '../../../blocs/post_grid_user/post_grid_bloc.dart';
import '../../../blocs/post_grid_user/post_grid_state.dart';

class PostGridImageScreen extends StatefulWidget {
  const PostGridImageScreen({Key? key}) : super(key: key);
  @override
  State<PostGridImageScreen> createState() => _PostGridImageScreenState();
}

class _PostGridImageScreenState extends State<PostGridImageScreen> {
  final String urlBase = ApiConstants.baseUrl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllImagePostGridBloc, ImagePostState>(
      builder: (context, state) {
        switch (state.status) {
          case ImagePostStatus.failure:
            return const Center(
              child: Text('We have a problem with server...'),
            );
          case ImagePostStatus.success:
            if (state.imagePostGrid.isEmpty) {
              return const Center(
                child: Text('You not have any post to view'),
              );
            }
            return GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                  state.imagePostGrid.length,
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
                            // child: CachedNetworkImage(
                            //     placeholderFadeInDuration:
                            //         const Duration(seconds: 10),
                            //     placeholder: (context, url) =>
                            //         Image.asset('assets/images/reload.gif'),
                            //     errorWidget: (context, url, error) =>
                            //         Image.asset(
                            //             'assets/images/image_notfound.png'),
                            //     imageUrl:
                            //         '$urlBase/download/${state.imagePostGrid[index].image}'),
                            child: InstaImageViewer(
                              child: Image(
                                image: Image.network(
                                        '$urlBase/download/${state.imagePostGrid[index].image}')
                                    .image,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                        'assets/images/image_notfound.png'),
                              ),
                              // imageUrl:
                              //     '$urlBase/download/${state.imagePostGrid[index].image}',
                              // placeholder: (BuildContext context) =>
                              //     Image.asset('assets/images/reload.gif'),
                              // errorWidget:
                              //     (BuildContext context, Object error) =>
                              //         Image.asset(
                              //             'assets/images/image_notfound.png'),
                            ),
                          ),
                        ),
                      )),
            );
          case ImagePostStatus.initial:
            return Center(
              child: LoadingAnimationWidget.dotsTriangle(
                  color: const Color.fromARGB(255, 6, 49, 122), size: 45),
            );
        }
      },
    );
  }
}
