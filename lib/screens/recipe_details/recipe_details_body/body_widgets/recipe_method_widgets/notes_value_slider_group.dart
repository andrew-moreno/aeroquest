import 'package:aeroquest/models/note.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/value_slider_group_template.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/providers/recipes_provider.dart';

class NotesValueSlider extends StatefulWidget {
  const NotesValueSlider({
    Key? key,
    required this.maxWidth,
    this.notesData,
  }) : super(key: key);

  final double maxWidth;
  final Note? notesData;

  @override
  State<NotesValueSlider> createState() => _NotesValueSliderState();
}

class _NotesValueSliderState extends State<NotesValueSlider> {
  /// initializing setting values when modal sheet activated
  /// default values set when no values are passed (eg. adding new bean settings)
  @override
  void initState() {
    super.initState();
    Provider.of<RecipesProvider>(context, listen: false).tempNoteTime =
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
