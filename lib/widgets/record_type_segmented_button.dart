import 'package:bill/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RecordTypeSegmentedButton extends StatefulWidget {
  final RecordTypeSegmentedButtonSelectionChangedCallback onSelectionChanged;

  const RecordTypeSegmentedButton({
    super.key,
    required this.onSelectionChanged,
    required this.isInitialExpense,
  });

  @override
  State<RecordTypeSegmentedButton> createState() =>
      _RecordTypeSegmentedButtonState();

  final bool isInitialExpense;
}

typedef RecordTypeSegmentedButtonSelectionChangedCallback = void Function(bool);

class _RecordTypeSegmentedButtonState extends State<RecordTypeSegmentedButton> {
  bool isExpense = true;

  @override
  void initState() {
    super.initState();
    isExpense = widget.isInitialExpense;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return SegmentedButton<bool>(
      segments: <ButtonSegment<bool>>[
        ButtonSegment<bool>(
          value: true,
          label: Text(localizations.general_Cost),
        ),
        ButtonSegment<bool>(
          value: false,
          label: Text(localizations.general_Earned),
        ),
      ],
      selected: <bool>{isExpense},
      onSelectionChanged: (Set<bool> newSelection) {
        setState(() {
          isExpense = newSelection.first;
          widget.onSelectionChanged(isExpense);
        });
      },
    );
  }
}
