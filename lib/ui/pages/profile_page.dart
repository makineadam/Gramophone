import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/app/configs/colors.dart';
import 'package:social_media_app/app/configs/theme.dart';
import 'package:social_media_app/ui/bloc/gallery_profile_cubit.dart';
import 'package:social_media_app/ui/bloc/post_cubit.dart';
import 'package:social_media_app/ui/pages/login_page.dart';
import 'package:social_media_app/ui/widgets/card_post.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key, required this.email, required this.id})
      : super(key: key);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final String email;
  final String id;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 24,
            color: AppColors.blackColor,
          ),
        ),
        title: Text(
          email,
          style: AppTheme.blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: AppTheme.bold,
          ),
        ),
        actions: const [
          Icon(
            Icons.more_horiz_rounded,
            size: 24,
            color: AppColors.blackColor,
          ),
          SizedBox(width: 24),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 24, left: 24, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImageProfile(),
                  const SizedBox(height: 16),
                  Text(
                    FirebaseAuth.instance.currentUser!.email!,
                    style: AppTheme.blackTextStyle.copyWith(
                      fontWeight: AppTheme.bold,
                      fontSize: 22,
                    ),
                  ),
                  //const SizedBox(height: 24),
                  //_buildDescription(),
                  const SizedBox(height: 24),
                  _buildButtonAction(),
                  const SizedBox(height: 35),
                  _buildTabBar(),
                  const SizedBox(height: 24),
                  BlocProvider(
                    create: (context) => PostCubit()..getPosts(id),
                    child: BlocBuilder<PostCubit, PostState>(
                      builder: (context, state) {
                        if (state is PostError) {
                          return Center(child: Text(state.message));
                        } else if (state is PostLoaded) {
                          return Column(
                            children: [
                              Column(
                                children: state.posts
                                    .map((post) => GestureDetector(
                                          child: CardPost(post: post),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 200)
                            ],
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBackgroundGradient()
        ],
      ),
    );
  }

  Row _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Uploaded Audio",
          style: AppTheme.blackTextStyle.copyWith(
            fontWeight: AppTheme.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Row _buildButtonAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor2,
            minimumSize: const Size(120, 45),
            elevation: 8,
            shadowColor: AppColors.primaryColor.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('Follow',
              style: AppTheme.whiteTextStyle
                  .copyWith(fontWeight: AppTheme.semiBold)),
        ),
        const SizedBox(width: 12),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.greyColor.withOpacity(0.17),
            image: const DecorationImage(
              scale: 2.3,
              image: AssetImage("assets/images/ic_inbox.png"),
            ),
          ),
        )
      ],
    );
  }

  Container _buildImageProfile() {
    return Container(
      width: 130,
      height: 130,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.dashedLineColor,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.asset(
          _firebaseAuth.currentUser!.email! == 'berk@gmail.com'
              ? 'assets/images/berk.png'
              : 'assets/images/ali.jpeg',
          width: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _buildBackgroundGradient() => Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppColors.whiteColor.withOpacity(0),
            AppColors.whiteColor.withOpacity(0.8),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
      );
}
