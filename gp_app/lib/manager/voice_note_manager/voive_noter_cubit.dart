import 'package:bloc/bloc.dart';
import 'package:gp_app/manager/voice_note_manager/audio_recorder_file.dart';
import 'package:gp_app/manager/voice_note_manager/voice_note_state.dart';
import 'package:gp_app/models/voice_note_model.dart';

class VoiceNotesCubit extends Cubit<VoiceNotesState> {
  final AudioRecorderFileHelper audioRecorderFileHelper;
  VoiceNotesCubit(this.audioRecorderFileHelper) : super(VoiceNotesInitial());

  int get fetchLimit => audioRecorderFileHelper.fetchLimit;

  void getAllVoiceNotes(int pageKey) async {
    try {
      final voiceNotes = await audioRecorderFileHelper.fetchVoiceNotes(pageKey);
      emit(VoiceNotesFetched(voiceNotes: voiceNotes));
    } catch (e) {
      emit(const VoiceNotesError(message: 'error'));
    }
  }

  void deleteRecordFile(VoiceNoteModel voiceNoteModel) async {
    try {
      await audioRecorderFileHelper.deleteRecord(voiceNoteModel.path);
      emit(VoiceNoteDeleted(voiceNoteModel: voiceNoteModel));
    } catch (e) {
      print(e.toString());
    }
  }

  void addToVoiceNotes(VoiceNoteModel voiceNoteModel) async {
    emit(VoiceNoteAdded(voiceNoteModel: voiceNoteModel));
  }
}
