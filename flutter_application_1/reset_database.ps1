# Script para resetar o banco de dados do Flutter

Write-Host "🔧 Reset do Banco de Dados - Flutter App" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Possíveis locais do banco
$possiblePaths = @(
    "$env:LOCALAPPDATA\flutter_application_1\app_flutter\databases\apollo.db",
    "$env:APPDATA\flutter_application_1\app_flutter\databases\apollo.db",
    ".\build\windows\runner\Debug\data\flutter_assets\databases\apollo.db"
)

$found = $false

foreach ($dbPath in $possiblePaths) {
    if (Test-Path $dbPath) {
        $found = $true
        Write-Host "📍 Banco encontrado em:" -ForegroundColor Yellow
        Write-Host "   $dbPath`n" -ForegroundColor Gray
        
        $confirm = Read-Host "Deseja deletar o banco? (S/N)"
        
        if ($confirm -eq 'S' -or $confirm -eq 's') {
            try {
                Remove-Item $dbPath -Force
                Write-Host "✅ Banco deletado com sucesso!" -ForegroundColor Green
                Write-Host "   Execute o app para recriar as tabelas.`n" -ForegroundColor Gray
            } catch {
                Write-Host "❌ Erro ao deletar: $_" -ForegroundColor Red
            }
        } else {
            Write-Host "❌ Operação cancelada." -ForegroundColor Red
        }
        break
    }
}

if (-not $found) {
    Write-Host "⚠️  Banco não encontrado nos locais padrão." -ForegroundColor Yellow
    Write-Host "`nLocais verificados:" -ForegroundColor Gray
    foreach ($path in $possiblePaths) {
        Write-Host "   - $path" -ForegroundColor DarkGray
    }
    Write-Host "`n💡 O banco será criado automaticamente ao executar o app." -ForegroundColor Cyan
}

Write-Host "`n🚀 Próximos passos:" -ForegroundColor Cyan
Write-Host "   1. Execute: flutter clean" -ForegroundColor White
Write-Host "   2. Execute: flutter pub get" -ForegroundColor White
Write-Host "   3. Execute: flutter run -d windows`n" -ForegroundColor White

Read-Host "Pressione Enter para sair"
