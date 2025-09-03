# push-to-github.ps1
param(
    [string]$RepoUrl = "https://github.com/jmfu003-web/x606f-sukisu-builder.git"
)

git init
git add .
git commit -m "Initial commit for X606F kernel builder with SukiSU"
git branch -M main
git remote add origin $RepoUrl
git push -u origin main
