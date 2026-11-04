# publish.ps1 - 把本仓库推到你的 GitHub
# 用法：powershell -ExecutionPolicy Bypass -File .\publish.ps1
#       powershell -ExecutionPolicy Bypass -File .\publish.ps1 -Private
param(
  [string]$RepoName = "dsh-purge-1.1.71",
  [switch]$Private
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

if (-not (Test-Path ".git")) { throw "当前目录不是 git 仓库：$PSScriptRoot" }

$repoDesc = "Source archive of dsh-purge v1.1.71 (upstream: YuJunZhiXue/dsh-purge), MIT, packed 2026-10-11"

Write-Host "== 1/4 读取 token ==" -ForegroundColor Cyan
Write-Host "   GitHub -> Settings -> Developer settings -> Tokens (classic) -> 勾 repo"
$sec = Read-Host "   粘贴 Personal Access Token（输入不显示）" -AsSecureString
$tk = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec))
if ([string]::IsNullOrWhiteSpace($tk)) { throw "token 为空，已退出" }

$headers = @{
  Authorization = "Bearer $tk"
  Accept        = "application/vnd.github+json"
  "User-Agent"  = "dsh-purge-archive"
}

Write-Host "== 2/4 校验账号 ==" -ForegroundColor Cyan
$me = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers
$owner = $me.login
Write-Host "   账号：$owner"

Write-Host "== 3/4 创建仓库 ==" -ForegroundColor Cyan
$body = @{ name = $RepoName; description = $repoDesc; private = [bool]$Private } | ConvertTo-Json
try {
  $created = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body
  Write-Host "   已创建：$($created.html_url)"
} catch {
  Write-Host "   创建返回：$($_.Exception.Message)" -ForegroundColor Yellow
  Write-Host "   （若提示已存在，就当作继续推送）"
}

Write-Host "== 4/4 推送 ==" -ForegroundColor Cyan
git remote remove origin 2>$null
git remote add origin "https://github.com/$owner/$RepoName.git"
# 用临时的 token URL 推送，推送后立刻把 remote 还原成不带凭据的地址
$pushUrl = "https://x-access-token:$tk@github.com/$owner/$RepoName.git"
git -c credential.helper= push $pushUrl master:master
if ($LASTEXITCODE -ne 0) { throw "push 失败（看上面的 git 报错）" }

git tag -a v1.1.71 -m "dsh-purge 1.1.71 source archive (pre-fix, packed 2026-10-11)" 2>$null
git -c credential.helper= push $pushUrl v1.1.71 2>$null

$tk = $null
[GC]::Collect()

Write-Host ""
Write-Host "完成：https://github.com/$owner/$RepoName" -ForegroundColor Green
Write-Host "别忘了把原始 tgz 挂到 Release 页（md5 49485903584ef950091e83bca94d360f）" -ForegroundColor DarkGray
