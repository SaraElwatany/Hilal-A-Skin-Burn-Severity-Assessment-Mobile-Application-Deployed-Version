import 'package:equatable/equatable.dart';
import 'package:gp_app/models/voice_note_model.dart';

abstract class VoiceNotesState extends Equatable {
  const VoiceNotesState();

  @override
  List<Object> get props => [];
}

class VoiceNotesInitial extends VoiceNotesState {}

class VoiceNotesLoading extends VoiceNotesState {}

class VoiceNotesFetched extends VoiceNotesState {
  final List<VoiceNoteModel> voiceNotes;
  const VoiceNotesFetched({required this.voiceNotes});

  @override
  List<Object> get props => [voiceNotes];
}

class VoiceNotesError extends VoiceNotesState {
  final String message;
  const VoiceNotesError({required this.message});

  @override
  List<Object> get props => [message];
}

class VoiceNoteDeleted extends VoiceNotesState {
  final VoiceNoteModel voiceNoteModel;
  const VoiceNoteDeleted({required this.voiceNoteModel});

  @override
  List<Object> get props => [voiceNoteModel];
}

class VoiceNoteAdded extends VoiceNotesState {
  final VoiceNoteModel voiceNoteModel;
  const VoiceNoteAdded({required this.voiceNoteModel});

  @override
  List<Object> get props => [voiceNoteModel];
}
