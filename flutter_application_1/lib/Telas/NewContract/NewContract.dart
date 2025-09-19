import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/ContractService.dart';
import 'package:intl/intl.dart';
import 'package:pdfx/pdfx.dart'; // 1. Importe o pacote

class NewContractScreen extends StatefulWidget {
  const NewContractScreen({Key? key}) : super(key: key);

  @override
  _NewContractScreenState createState() => _NewContractScreenState();
}

class _NewContractScreenState extends State<NewContractScreen> {
  final _contractService = ContractService();
  final _contractNameController = TextEditingController();
  final _notesController = TextEditingController();

  PlatformFile? _selectedFile;
  Map<String, dynamic>? _processedData;
  bool _isLoading = false;
  String? _statusMessage;
  Color _messageColor = Colors.black;

  // 2. Adicione o controller para o PDF
  PdfController? _pdfController;

  @override
  void dispose() {
    // 3. Garanta que o controller seja liberado da memória
    _pdfController?.dispose();
    _contractNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _resetScreen() {
    setState(() {
      _pdfController?.dispose(); // Limpa o controller antigo
      _pdfController = null;
      _selectedFile = null;
      _processedData = null;
      _statusMessage = null;
      _isLoading = false;
      _contractNameController.clear();
      _notesController.clear();
    });
  }

  Future<void> _pickFile() async {
    _resetScreen();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // 4. MUITO IMPORTANTE: Peça os bytes do arquivo
    );

    if (result != null && result.files.first.bytes != null) {
      final file = result.files.first;
      setState(() {
        _selectedFile = file;
        // 5. Inicialize o controller com os bytes do arquivo
        _pdfController = PdfController(
          document: PdfDocument.openData(file.bytes!),
        );
      });
    } else {
      // O usuário cancelou ou o arquivo não veio com os dados
      setState(() {
        _statusMessage = "Não foi possível carregar o arquivo PDF.";
        _messageColor = Colors.red;
      });
    }
  }

  Future<void> _uploadAndProcess() async {
    // ... (nenhuma mudança aqui, o método continua o mesmo)
    if (_selectedFile == null) return;

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
      _processedData = null;
    });

    try {
      final result = await _contractService.uploadAndProcessContract(
        file: _selectedFile!,
        customName: _contractNameController.text.isNotEmpty
            ? _contractNameController.text
            : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
      setState(() {
        _statusMessage = 'Contrato processado e salvo com sucesso!';
        _messageColor = Colors.green;
        _processedData = result;
        _pdfController?.dispose(); // Libera o PDF da memória após o sucesso
        _pdfController = null;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Erro: ${e.toString().replaceAll("Exception: ", "")}';
        _messageColor = Colors.red;
      });
    } finally {
      setState(() => _isLoading = false);
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
            if (_processedData == null) ...[
              OutlinedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text('Selecionar PDF'),
                onPressed: _isLoading ? null : _pickFile,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              // O preview do PDF será renderizado aqui
              if (_pdfController != null) _buildPdfPreview(),
              const SizedBox(height: 24),
              if (_selectedFile != null) ...[
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
              ],
            ],
            const SizedBox(height: 24),
            if (_statusMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _statusMessage!,
                    style: TextStyle(color: _messageColor, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (_processedData != null) _buildResultsCard(_processedData!),
          ],
        ),
      ),
    );
  }

  // 6. NOVO WIDGET para mostrar o PDF
  Widget _buildPdfPreview() {
    return Column(
      children: [
        Text(
          _selectedFile!.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 400, // Defina uma altura para o visualizador
          child: Card(
            elevation: 4,
            child: PdfView(
              controller: _pdfController!,
              scrollDirection: Axis.vertical,
            ),
          ),
        ),
      ],
    );
  }

  // Widget de resultados (sem alterações)
  Widget _buildResultsCard(Map<String, dynamic> data) {
    final partners = data['partners'] as List;
    final currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Column(
      children: [
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resultados da Análise',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 20),
                ListTile(
                  leading: const Icon(Icons.business),
                  title: Text(data['company_name'] ?? 'Não informado'),
                  subtitle: const Text('Nome da Empresa'),
                ),
                ListTile(
                  leading: const Icon(Icons.pin),
                  title: Text(data['cnpj'] ?? 'Não informado'),
                  subtitle: const Text('CNPJ'),
                ),
                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: Text(
                    currencyFormatter.format(data['capital_social'] ?? 0),
                  ),
                  subtitle: const Text('Capital Social'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sócios Encontrados',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                for (var partner in partners)
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(partner['name']),
                    subtitle: Text(partner['role']),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Analisar Outro Contrato'),
          onPressed: _resetScreen,
        ),
      ],
    );
  }
}
