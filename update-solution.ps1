# Export Power Platform solution and push to GitHub
# Solution: DiscrepancyManagement
# Branch: master

$solutionName = "DiscrepancyManagement"
$zipFile = "./solution.zip"
$unpackFolder = "./src/Solution"
$gitBranch = "master"
$logFile = "./update-log.txt"

# Remove old zip if exists
if (Test-Path $zipFile) {
    Remove-Item $zipFile
}

# Pull latest from remote to avoid conflicts
Write-Host "Pulling latest from GitHub branch '$gitBranch'..."
git pull --rebase origin $gitBranch

# Export solution from Power Platform
Write-Host "Exporting solution '$solutionName'..."
pac solution export --path $zipFile --name $solutionName --managed false

# Unpack solution into source structure
Write-Host "Unpacking solution to '$unpackFolder'..."
pac solution unpack --zipfile $zipFile --folder $unpackFolder --packagetype Unmanaged

# Clean up any old unnecessary unpack files if needed
Get-ChildItem -Recurse $unpackFolder -Include "*.bak","*.tmp" | Remove-Item -Force -ErrorAction SilentlyContinue

# Git add, commit, push
Write-Host "Adding changes to Git..."
git add .

$timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$commitMessage = "Update DiscrepancyManagement solution: $timeStamp"

Write-Host "Committing changes..."
git commit -m "$commitMessage"

Write-Host "Pushing to branch '$gitBranch'..."
git push -u origin $gitBranch

# Log this update
$lastCommit = git rev-parse HEAD
"[$timeStamp] Updated to commit $lastCommit" | Out-File -Append -Encoding utf8 $logFile

Write-Host "Done. Latest commit: $lastCommit"
