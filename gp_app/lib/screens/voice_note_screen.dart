import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:gp_app/manager/voice_note_manager/audio_recorder_file.dart';
import 'package:gp_app/manager/voice_note_manager/voice_note_state.dart';
import 'package:gp_app/manager/voice_note_manager/voive_noter_cubit.dart';
import 'package:gp_app/models/voice_note_model.dart';
import 'package:gp_app/widgets/audio_recorder_view.dart';
import 'package:gp_app/widgets/voice_note_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:gp_app/utils/app_bottom_sheet.dart';
import 'package:gp_app/utils/constants/app_colors.dart';
import 'package:gp_app/utils/constants/app_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoiceNoteScreen extends StatelessWidget {
  const VoiceNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VoiceNotesCubit(AudioRecorderFileHelper()),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody({super.key});

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  final PagingController<int, VoiceNoteModel> pagingController =
      PagingController<int, VoiceNoteModel>(
          firstPageKey: 1, invisibleItemsThreshold: 6);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      context.read<VoiceNotesCubit>().getAllVoiceNotes(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  void onDataFetched(VoiceNotesFetched state) {
    final data = state.voiceNotes;

    final isLastPage = data.isEmpty ||
        data.length < context.read<VoiceNotesCubit>().fetchLimit;
    if (isLastPage) {
      pagingController.appendLastPage(data);
    } else {
      final nextPageKey = (pagingController.nextPageKey ?? 0) + 1;
      pagingController.appendPage(data, nextPageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: BlocListener<VoiceNotesCubit, VoiceNotesState>(
                        listener: (context, state) {
                          if (state is VoiceNotesError) {
                            pagingController.error = state.message;
                          } else if (state is VoiceNotesFetched) {
                            onDataFetched(state);
                          } else if (state is VoiceNoteDeleted) {
                            final List<VoiceNoteModel> voiceNotes = List.from(
                                pagingController.value.itemList ?? []);
                            voiceNotes.remove(state.voiceNoteModel);
                            pagingController.itemList = voiceNotes;
                          } else if (state is VoiceNoteAdded) {
                            final List<VoiceNoteModel> newItems =
                                List.from(pagingController.itemList ?? []);
                            newItems.insert(0, state.voiceNoteModel);
                            pagingController.itemList = newItems;
                          }
                        },
                        child: PagedListView<int, VoiceNoteModel>(
                          pagingController: pagingController,
                          padding: const EdgeInsets.only(
                              right: 24, left: 24, bottom: 80),
                          builderDelegate: PagedChildBuilderDelegate(
                            noItemsFoundIndicatorBuilder: (context) {
                              return const Column(children: [
                                SizedBox(
                                  height: 55,
                                ),
                              ]);
                            },
                            itemBuilder: (context, item, index) {
                              return VoiceNoteCard(voiceNoteInfo: item);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
