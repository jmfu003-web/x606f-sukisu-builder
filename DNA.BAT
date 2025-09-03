@echo off
:: 请在运行前解压 x606f-sukisu-builder.zip，并进入该目录
:: 修改下面的 GitHub 仓库地址
set REPO_URL=https://github.com/<YourGitHubUsername>/x606f-sukisu-builder.git

echo 初始化 Git 仓库...
git init

echo 添加文件...
git add .

echo 提交代码...
git commit -m "Initial commit for X606F kernel builder with SukiSU"

echo 创建 main 分支...
git branch -M main

echo 添加远程仓库 %REPO_URL% ...
git remote add origin %REPO_URL%

echo 推送到 GitHub...
git push -u origin main

echo 完成！请在 GitHub 查看你的仓库。
pause
