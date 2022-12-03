import 'package:aeroquest/models/note.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/providers/settings_slider_provider.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/value_slider_group_template.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesValueSlider extends StatefulWidget {
  /// Initializes the slider group for editing notes specifically
  const NotesValueSlider({
    Key? key,
    required this.maxWidth,
    this.notesData,
  }) : super(key: key);

  /// Max width passed from the parent widget
  final double maxWidth;

  /// Notes data to be edited
  final Note? notesData;

  @override
  State<NotesValueSlider> createState() => _NotesValueSliderState();
}

class _NotesValueSliderState extends State<NotesValueSlider> {
  /// Initializing note values when modal sheet activated
  ///
  /// Default values set when no values are passed
  /// (adding new notes)
  @override
  void initState() {
    super.initState();
    Provider.of<SettingsSliderProvider>(context, listen: false).tempNoteTime =
        widget.notesData?.time ?? 0;
    Provider.of<RecipesProvider>(context, listen: false).activeSlider =
        ParameterType.none;
  }

  @override
  Widget build(BuildContext context) {
    return ValueSliderGroupTemplate(
      maxWidth: widget.maxWidth,
      modalType: ModalType.notes,
    );
  }
}
