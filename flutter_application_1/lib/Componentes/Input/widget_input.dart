import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class WidgetInput extends StatelessWidget {
  final String? rotulo;
  final String? hinText;
  final String? Function(String?)? validator;
  final TextInputType? type;
  final int? maxLength;
  final TextEditingController? controller;
  final String? maskType;
  final void Function(String)? onChanged;
  final bool enable;

  const WidgetInput({
    required this.rotulo,
    required this.hinText,
    this.validator,
    super.key,
    this.type = TextInputType.text,
    this.maxLength = 50,
    this.controller,
    this.maskType,
    this.onChanged,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    MaskTextInputFormatter? maskFormatter;
    TextInputType? keyboardType = type;

    if (maskType != null) {
      if (maskType == 'telefone') {
        maskFormatter = MaskTextInputFormatter(
          mask: '(##) #####-####',
          filter: {"#": RegExp(r'[0-9]')},
          type: MaskAutoCompletionType.lazy,
        );
        keyboardType = TextInputType.phone;
      } else if (maskType == 'preco') {
        maskFormatter = MaskTextInputFormatter(
          mask: '###.###,##',
          filter: {"#": RegExp(r'[0-9]')},
          type: MaskAutoCompletionType.lazy,
        );
        keyboardType = TextInputType.numberWithOptions(decimal: true);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          rotulo!,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
            hintText: hinText!,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            counterText: '',
          ),
          enabled: enable,
          keyboardType: keyboardType,
          validator: validator,
          maxLength: maxLength,
          controller: controller,
          inputFormatters: maskFormatter != null ? [maskFormatter] : [],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
