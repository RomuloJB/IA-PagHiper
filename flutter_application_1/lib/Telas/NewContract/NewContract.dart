import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/ContractService.dart';

class NewContractScreen extends StatefulWidget {
  const NewContractScreen({Key? key}) : super(key: key);

  @override
  _NewContractScreenState createState() => _NewContractScreenState();
}

class _NewContractScreenState extends State<NewContractScreen> {
  final _contractService = ContractService();
  final _contractNameController = TextEditingController();
  final _notesController = TextEditingController();

  // Variáveis de estado da UI
  PlatformFile? _selectedFile;
  bool _isLoading = false;
  String? _statusMessage;
  Color _messageColor = Colors.black;

  // Método para escolher o arquivo
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
        _statusMessage = null; // Limpa mensagens anteriores
      });
    }
  }

  // Método principal que é chamado pelo botão
  Future<void> _uploadAndProcess() async {
    if (_selectedFile == null) return;

    // Validação de tela
    final validationError = _contractService.validateFile(_selectedFile!);
    if (validationError != null) {
      setState(() {
        _statusMessage = validationError;
        _messageColor = Colors.red;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Enviando e processando...';
      _messageColor = Colors.blue;
    });

    try {
      await _contractService.uploadAndProcessContract(
        file: _selectedFile!,
        customName: _contractNameController.text.isNotEmpty
            ? _contractNameController.text
            : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
      setState(() {
        _statusMessage = 'Contrato processado e salvo com sucesso!';
        _messageColor = Colors.green;
        _selectedFile = null; // Limpa o arquivo para o próximo upload
        _contractNameController.clear();
        _notesController.clear();
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Erro: ${e.toString().replaceAll("Exception: ", "")}';
        _messageColor = Colors.red;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Contrato')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botão para escolher PDF
            OutlinedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Selecionar PDF'),
              onPressed: _isLoading ? null : _pickFile,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Mostra o nome do arquivo selecionado
            if (_selectedFile != null)
              Center(
                child: Text(
                  'Arquivo: ${_selectedFile!.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 24),

            // Campos opcionais
            TextField(
              controller: _contractNameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Contrato (Opcional)',
                border: OutlineInputBorder(),
              ),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Observações (Opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 24),

            // Botão de Envio
            ElevatedButton(
              onPressed: (_selectedFile == null || _isLoading)
                  ? null
                  : _uploadAndProcess,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Text('Enviar Contrato'),
            ),
            const SizedBox(height: 24),

            // Mensagem de status e retorno
            if (_statusMessage != null)
              Center(
                child: Text(
                  _statusMessage!,
                  style: TextStyle(color: _messageColor, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
