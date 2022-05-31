import 'package:cycling_escape/widget/general/styled/cycling_escape_input_field.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class EditNameDialog extends StatefulWidget {
  final String initialValue;

  const EditNameDialog({
    required this.initialValue,
    super.key,
  });

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  late final _textController = TextEditingController(text: widget.initialValue);

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilder: (context, theme, localization) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TouchFeedBack(
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.close),
                  ),
                  onClick: () => Navigator.of(context).pop(null),
                ),
              ),
              CyclingEscapeInputField(
                hint: 'name',
                onChanged: (_) {},
                controller: _textController,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: TouchFeedBack(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      localization.okButton,
                      style: theme.inverseCoreTextTheme.bodyNormal,
                    ),
                  ),
                  onClick: () => Navigator.of(context).pop(_textController.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
