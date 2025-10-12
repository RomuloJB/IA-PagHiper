import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Banco/DAO/ProcessingProtocolDAO.dart';
import 'package:flutter_application_1/Banco/entidades/ProcessingProtocol.dart';
import 'package:intl/intl.dart';

class ProtocolSearchScreen extends StatefulWidget {
  const ProtocolSearchScreen({Key? key}) : super(key: key);

  @override
  _ProtocolSearchScreenState createState() => _ProtocolSearchScreenState();
}

class _ProtocolSearchScreenState extends State<ProtocolSearchScreen> {
  final _protocolDao = ProcessingProtocolDao();
  final _searchController = TextEditingController();

  List<ProcessingProtocol> _allProtocols = [];
  ProcessingProtocol? _searchedProtocol;
  bool _isLoading = false;
  bool _showAllProtocols = false;

  @override
  void initState() {
    super.initState();
    _loadAllProtocols();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllProtocols() async {
    setState(() => _isLoading = true);
    try {
      final protocols = await _protocolDao.readAll();
      setState(() {
        _allProtocols = protocols;
        _showAllProtocols = true;
      });
    } catch (e) {
      _showSnack('Erro ao carregar protocolos: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchProtocol() async {
    final code = _searchController.text.trim().toUpperCase();
    if (code.isEmpty) {
      _showSnack('Digite um código de protocolo', Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
      _searchedProtocol = null;
      _showAllProtocols = false;
    });

    try {
      final protocol = await _protocolDao.read(code);
      setState(() {
        _searchedProtocol = protocol;
      });

      if (protocol == null) {
        _showSnack('Protocolo não encontrado', Colors.red);
      }
    } catch (e) {
      _showSnack('Erro ao buscar protocolo: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Consultar Protocolo'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0857C3),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de busca
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buscar por Código',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Código do Protocolo',
                        hintText: 'Ex: CTR-2025-ABC123',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchedProtocol = null;
                                      _showAllProtocols = true;
                                    });
                                  },
                                )
                                : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF0857C3),
                            width: 2,
                          ),
                        ),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (value) => setState(() {}),
                      onSubmitted: (_) => _searchProtocol(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.search),
                            label: const Text('Buscar'),
                            onPressed: _isLoading ? null : _searchProtocol,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0857C3),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.list),
                            label: const Text('Ver Todos'),
                            onPressed:
                                _isLoading
                                    ? null
                                    : () {
                                      _searchController.clear();
                                      _loadAllProtocols();
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF24d17a),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Resultado da busca ou lista
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_searchedProtocol != null)
              _buildProtocolCard(_searchedProtocol!)
            else if (_showAllProtocols && _allProtocols.isNotEmpty) ...[
              const Text(
                'Histórico de Protocolos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 12),
              ..._allProtocols.map(
                (protocol) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildProtocolCard(protocol),
                ),
              ),
            ] else if (!_showAllProtocols &&
                _searchedProtocol == null &&
                _searchController.text.isNotEmpty)
              _buildEmptyState('Protocolo não encontrado', Icons.search_off)
            else if (_allProtocols.isEmpty)
              _buildEmptyState('Nenhum protocolo registrado', Icons.inbox),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolCard(ProcessingProtocol protocol) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    Color statusColor;
    IconData statusIcon;

    switch (protocol.status) {
      case 'completed':
        statusColor = const Color(0xFF24d17a);
        statusIcon = Icons.check_circle;
        break;
      case 'failed':
        statusColor = Colors.redAccent;
        statusIcon = Icons.error;
        break;
      case 'processing':
        statusColor = const Color(0xFF0857C3);
        statusIcon = Icons.hourglass_empty;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: protocol.protocolCode));
          _showSnack('Código copiado!', const Color(0xFF24d17a));
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          protocol.protocolCode,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        Text(
                          protocol.fileName ?? 'Sem nome',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: protocol.protocolCode),
                      );
                      _showSnack('Código copiado!', const Color(0xFF24d17a));
                    },
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildInfoRow(
                'Status:',
                _getStatusLabel(protocol.status),
                statusColor,
              ),
              if (protocol.currentStep != null)
                _buildInfoRow(
                  'Etapa:',
                  _getStepLabel(protocol.currentStep!),
                  null,
                ),
              if (protocol.progress != null)
                _buildProgressBar(protocol.progress!),
              _buildInfoRow(
                'Criado:',
                dateFormat.format(DateTime.parse(protocol.createdAt)),
                null,
              ),
              if (protocol.completedAt != null)
                _buildInfoRow(
                  'Concluído:',
                  dateFormat.format(DateTime.parse(protocol.completedAt!)),
                  null,
                ),
              if (protocol.errorMessage != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          protocol.errorMessage!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? const Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progresso:',
                style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
              ),
              Text(
                '$progress%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 6,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF24d17a),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'Concluído';
      case 'failed':
        return 'Falhou';
      case 'processing':
        return 'Processando';
      case 'pending':
        return 'Pendente';
      default:
        return status;
    }
  }

  String _getStepLabel(String step) {
    switch (step) {
      case 'upload':
        return 'Upload';
      case 'validation':
        return 'Validação';
      case 'analysis':
        return 'Análise IA';
      case 'extraction':
        return 'Extração';
      case 'saving':
        return 'Salvando';
      default:
        return step;
    }
  }
}
