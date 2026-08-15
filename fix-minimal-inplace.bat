@echo off
chcp 65001 >nul
echo 正在请求管理员权限以修复 dsh 极简模式预设...
echo 请在弹出的 UAC 对话框中点击"是"。
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell.exe -Verb RunAs -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File','F:\deepseek Harness\fix-minimal-inplace.ps1'"
if exist "F:\deepseek Harness\fix-minimal-inplace.log" (
  echo.
  echo 已检测到执行日志，修复可能已成功：
  type "F:\deepseek Harness\fix-minimal-inplace.log"
) else (
  echo.
  echo 未检测到执行日志。如果你取消了 UAC，请重新双击本文件。
)
echo.
pause
