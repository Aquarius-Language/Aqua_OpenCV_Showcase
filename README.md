# OpenCV 視覺實驗室

這是使用獨立 Bottle 套件 `Aqua_OpenCV` 1.1.1 的 TOML 主程式。`主程式.aqua`、`功能清單.aqua`、`功能驗證.aqua` 與 `雙語驗證.aqua` 使用繁體中文變數、函式、參數與回傳欄位，介面與操作提示也使用繁體中文。

```powershell
./build.ps1 -執行
./build.ps1 -驗證
./build.ps1 -平台 web
# 以 localhost 靜態伺服器提供 web 目錄後，開啟 index.html。
./build.ps1 -平台 android
```

腳本預設使用相鄰 AquariusLangTW 中更新的開發編譯器，也保留 `-Run`、`-Smoke`、`-Platform`、`-Compiler` 英文別名。可用 `-編譯器 aqua` 選擇已更新的全域 CLI。依賴由 `aqua.lock.json` 固定版本；快取完整時可用 `aqua build . --locked --offline --platform windows -o dist/showcase.wasm`。

左側分三頁列出 45 項功能。點選功能或按左右方向鍵切換，使用滑桿調整閾值與旋轉角度，按「核心」切換奇數核心大小。空白鍵或「重新處理」再次執行演算法。可開啟自己的影像、儲存 PNG，或重設內附範例。人臉與神經網路範例預設使用內附肖像。

功能涵蓋色彩、濾鏡、邊緣、形態學、分割、增強、幾何、形狀偵測、特徵匹配、修復、頻域、運動、人臉、QR 碼與三維視覺。灰色項目表示目前後端未提供該功能。光流、視差及姿態範例使用已知的合成資料；姿態展示使用 solvePnP，不代表已完成真實相機的校正程序。全景拼接使用具有固定紋理的重疊影像。

Windows 與 Android 原生版提供 45 項功能；網頁 SIMD Wasm 版提供 36 項，以執行時回報的功能清單為準。Android 內附 ARM64 與 x86_64 原生庫。Linux/macOS 目前使用 SIMD Wasm 後端，原生編譯方式見函式庫文件。介面顯示的演算法耗時不包含解碼、PNG 傳輸與繪圖，不能視為完整應用程式的幀率。

`功能驗證.aqua` 驗證目前平台的全部功能、人臉結果、PNG 往返與資源釋放；`雙語驗證.aqua` 驗證中英文呼叫產生相同影像、中文尺寸與零閾值參數、雙語錯誤與功能資訊。
