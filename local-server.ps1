param([int]$Port = 8000)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootFull = [System.IO.Path]::GetFullPath($root)
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)

function Get-MimeType([string]$path) {
    switch ([System.IO.Path]::GetExtension($path).ToLowerInvariant()) {
        '.html' { 'text/html; charset=utf-8' }
        '.htm'  { 'text/html; charset=utf-8' }
        '.js'   { 'text/javascript; charset=utf-8' }
        '.mjs'  { 'text/javascript; charset=utf-8' }
        '.json' { 'application/json; charset=utf-8' }
        '.css'  { 'text/css; charset=utf-8' }
        '.svg'  { 'image/svg+xml' }
        '.png'  { 'image/png' }
        '.jpg'  { 'image/jpeg' }
        '.jpeg' { 'image/jpeg' }
        '.ico'  { 'image/x-icon' }
        default { 'application/octet-stream' }
    }
}

try {
    $listener.Start()
} catch {
    Write-Host "端口 $Port 无法使用，正在尝试 8001..." -ForegroundColor Yellow
    $Port = 8001
    $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)
    $listener.Start()
}

$url = "http://127.0.0.1:$Port/"
Write-Host ""
Write-Host "空间几何实验室已启动：$url" -ForegroundColor Green
Write-Host "关闭此窗口即可停止服务。" -ForegroundColor Cyan
Write-Host ""
Start-Process $url

while ($true) {
    $client = $listener.AcceptTcpClient()
    try {
        $stream = $client.GetStream()
        $reader = New-Object System.IO.StreamReader($stream, [System.Text.Encoding]::ASCII, $false, 4096, $true)
        $requestLine = $reader.ReadLine()
        if ([string]::IsNullOrWhiteSpace($requestLine)) { continue }

        while ($true) {
            $line = $reader.ReadLine()
            if ([string]::IsNullOrEmpty($line)) { break }
        }

        $parts = $requestLine.Split(' ')
        $method = $parts[0]
        $rawPath = if ($parts.Length -gt 1) { $parts[1] } else { '/' }
        $pathOnly = $rawPath.Split('?')[0]
        $decoded = [System.Uri]::UnescapeDataString($pathOnly)
        if ($decoded -eq '/') { $decoded = '/index.html' }
        $relative = $decoded.TrimStart('/').Replace('/', [System.IO.Path]::DirectorySeparatorChar)
        $fullPath = [System.IO.Path]::GetFullPath((Join-Path $rootFull $relative))

        $status = '200 OK'
        $body = $null
        $mime = 'text/plain; charset=utf-8'

        if (-not $fullPath.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
            $status = '403 Forbidden'
            $body = [System.Text.Encoding]::UTF8.GetBytes('Forbidden')
        } elseif (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
            $status = '404 Not Found'
            $body = [System.Text.Encoding]::UTF8.GetBytes('Not Found')
        } else {
            $mime = Get-MimeType $fullPath
            $body = [System.IO.File]::ReadAllBytes($fullPath)
        }

        $header = "HTTP/1.1 $status`r`nContent-Type: $mime`r`nContent-Length: $($body.Length)`r`nCache-Control: no-cache`r`nConnection: close`r`n`r`n"
        $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
        $stream.Write($headerBytes, 0, $headerBytes.Length)
        if ($method -ne 'HEAD') { $stream.Write($body, 0, $body.Length) }
        $stream.Flush()
    } catch {
        # 单个请求异常不影响服务器继续运行
    } finally {
        $client.Close()
    }
}
