import 'package:flutter/material.dart';

class ProcessingStepsWidget extends StatelessWidget {
  final String currentStep;
  final int progress;
  final String? protocolCode;

  const ProcessingStepsWidget({
    Key? key,
    required this.currentStep,
    required this.progress,
    this.protocolCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'id': 'upload', 'label': 'Upload', 'icon': Icons.cloud_upload},
      {'id': 'validation', 'label': 'Validação', 'icon': Icons.verified_user},
      {'id': 'analysis', 'label': 'Análise IA', 'icon': Icons.psychology},
      {'id': 'extraction', 'label': 'Extração', 'icon': Icons.document_scanner},
      {'id': 'saving', 'label': 'Salvando', 'icon': Icons.save},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (protocolCode != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.qr_code_2, color: Color(0xFF0857C3), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Protocolo: $protocolCode',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0857C3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          const Text(
            'Processando Contrato',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 24),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF24d17a),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$progress%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 24),

          // Steps
          Column(
            children:
                steps.map((step) {
                  final isActive = step['id'] == currentStep;
                  final stepIndex = steps.indexOf(step);
                  final currentIndex = steps.indexWhere(
                    (s) => s['id'] == currentStep,
                  );
                  final isCompleted = stepIndex < currentIndex;

                  return _buildStepItem(
                    icon: step['icon'] as IconData,
                    label: step['label'] as String,
                    isActive: isActive,
                    isCompleted: isCompleted,
                  );
                }).toList(),
          ),

          const SizedBox(height: 16),
          const Text(
            'Aguarde, não feche esta janela...',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF757575),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isCompleted,
  }) {
    Color color;
    if (isCompleted) {
      color = const Color(0xFF24d17a);
    } else if (isActive) {
      color = const Color(0xFF0857C3);
    } else {
      color = const Color(0xFFBDBDBD);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child:
                isCompleted
                    ? const Icon(
                      Icons.check,
                      color: Color(0xFF24d17a),
                      size: 20,
                    )
                    : Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? color : const Color(0xFF757575),
              ),
            ),
          ),
          if (isActive)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0857C3)),
              ),
            ),
        ],
      ),
    );
  }
}
