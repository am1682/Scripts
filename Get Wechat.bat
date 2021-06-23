::rem powershell -Command "(New-Object Net.WebClient).DownloadFile('https://dldir1.qq.com/weixin/Windows/WeChatSetup.exe', '%homepath%/Downloads/WeChatSetup.exe')"
powershell -Command "Start-BitsTransfer -Source 'https://dldir1.qq.com/weixin/Windows/WeChatSetup.exe' -Destination '%temp%\WeChatSetup.exe'"
::rem start "" "%homepath%/Downloads/"
explorer /select,"%temp%\WeChatSetup.exe"