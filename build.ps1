param(
 [Alias('Platform')][ValidateSet('windows','linux','macos','web','android')][string]$平台='windows',
 [Alias('Run')][switch]$執行,
 [Alias('Smoke')][switch]$驗證,
 [Alias('Compiler')][string]$編譯器=''
)
$ErrorActionPreference='Stop'
if(!$編譯器){$編譯器=Join-Path $PSScriptRoot '../AquariusLangTW/dist/aqua-current/aqua.exe';if(!(Test-Path $編譯器)){$編譯器=Join-Path $PSScriptRoot '../AquariusLangTW/AquariusCli/bin/Release/net8.0/aqua.dll'}}
$點網執行器=Join-Path $env:USERPROFILE '.dotnet/dotnet.exe';if(!(Test-Path $點網執行器)){$點網執行器='dotnet'}
function 呼叫編譯器 { if($編譯器.EndsWith('.dll')){& $點網執行器 $編譯器 @args}else{& $編譯器 @args};if($LASTEXITCODE){throw "Aquarius 執行失敗，結束代碼：$LASTEXITCODE"} }
Push-Location $PSScriptRoot
try {
 呼叫編譯器 bottle restore --project . --target $平台
 if($平台 -eq 'web'){
   # 先產生完整網站，再更新平面檔案；本機預覽伺服器可持續使用 web 目錄。
   $網站目錄=Join-Path $PSScriptRoot 'web'
   if((Test-Path $網站目錄) -and !(Test-Path (Join-Path $網站目錄 '.aquarius-web-output')) -and @(Get-ChildItem -LiteralPath $網站目錄 -Force).Count){throw 'web 目錄含有非編譯器產生的檔案。'}
   $暫存根目錄=[IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\','/')
   $暫存網站=Join-Path $暫存根目錄 ('aqua-opencv-web-'+[Guid]::NewGuid().ToString('N'))
   try {
     呼叫編譯器 build . --target web -o $暫存網站
     New-Item -ItemType Directory -Path $網站目錄 -Force | Out-Null
     foreach($檔案 in Get-ChildItem -LiteralPath $暫存網站 -File -Force){Copy-Item -LiteralPath $檔案.FullName -Destination (Join-Path $網站目錄 $檔案.Name) -Force}
     $網頁=Join-Path $網站目錄 'index.html'
     [IO.File]::WriteAllText($網頁,([IO.File]::ReadAllText($網頁).Replace('lang="en"','lang="zh-Hant"').Replace('<title>Aquarius WebAssembly</title>','<title>OpenCV 視覺實驗室</title>')))
     Write-Output "繁體中文網站已更新：$網站目錄"
   } finally {
     $確認路徑=[IO.Path]::GetFullPath($暫存網站)
     if([IO.Path]::GetDirectoryName($確認路徑) -ne $暫存根目錄 -or ![IO.Path]::GetFileName($確認路徑).StartsWith('aqua-opencv-web-')){throw '暫存網站路徑驗證失敗。'}
     if(Test-Path $確認路徑){foreach($檔案 in Get-ChildItem -LiteralPath $確認路徑 -File -Force){Remove-Item -LiteralPath $檔案.FullName -Force};Remove-Item -LiteralPath $確認路徑}
   }
 }
 elseif($平台 -eq 'android'){呼叫編譯器 build . --target android --application-id tw.aquariuslang.opencvshowcase --app-name 'OpenCV 視覺實驗室' -o dist/android}
 else {呼叫編譯器 build . --platform $平台 -o dist/showcase.wasm;if($驗證){呼叫編譯器 run dist/showcase.wasm --entry 功能驗證.aqua;呼叫編譯器 run dist/showcase.wasm --entry 雙語驗證.aqua};if($執行){呼叫編譯器 run dist/showcase.wasm}}
} finally {Pop-Location}
