import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gif_view/gif_view.dart';
import 'package:go_router/go_router.dart';

import '../../core/core.dart';
import '../base/base_cubit.dart';
import 'play.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayCubit(context.read<BaseCubit>())..onWidgetDidInit(),
      child: BlocBuilder<PlayCubit, PlayState>(
        builder: (context, state) {
          if (state is PlayLoadedState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Text(
                  "Play !",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${state.firstPlayerName}\'s turn',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 45, fontWeight: FontWeight.bold),
                ),
                const Gap(16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GifView.asset(
                      context
                          .read<PlayCubit>()
                          .getRandomGif(isBattle: state.isBattle),
                      height: 300,
                      width: 300,
                      progressBuilder: (context) => const LoadingScreen(),
                    ),
                    Text(
                      state.playText,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 26, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                const Spacer(),
                MyButton(
                  title: 'Check folds',
                  size: ButtonSizes.medium,
                  onPressed: () {
                    Router.neglect(context,
                        () => GoRouter.of(context).go(AppRoutes.checkFolds));
                  },
                )
              ],
            );
          }
          return const LoadingScreen();
        },
      ),
    );
  }
}
