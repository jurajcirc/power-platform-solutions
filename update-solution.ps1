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

# Pull latest from GitHub
Write-Host "Pulling latest from GitHub branch '$gitBranch'..."
git pull --rebase origin $gitBranch

# Export solution from Power Platform
Write-Host "Exporting solution '$solutionName'..."
pac solution export --path $zipFile --name $solutionName --managed false

# Unpack solution into source structure
Write-Host "Unpacking solution to '$unpackFolder'..."
pac solution unpack --zipfile $zipFile --folder $unpackFolder --packagetype Unmanaged

# Clean up any unnecessary files (optional patterns)
Get-ChildItem -Recurse $unpackFolder -Include "*.bak","*.tmp" | Remove-Item -Force -ErrorAction SilentlyContinue

# Git add & check for changes
Write-Host "Adding changes to Git..."
git add .

# Properly detect staged changes
git diff --cached --quiet
$hasChanges = ($LASTEXITCODE -eq 1)

if ($hasChanges) {
    $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $commitMessage = "Update DiscrepancyManagement solution: $timeStamp"

    Write-Host "Committing changes..."
    git commit -m "$commitMessage"

    Write-Host "Pushing to branch '$gitBranch'..."
    git push -u origin $gitBranch

    $lastCommit = git rev-parse HEAD
    "[$timeStamp] Updated to commit $lastCommit" | Out-File -Append -Encoding utf8 $logFile
    Write-Host "Done. Latest commit: $lastCommit"
}
else {
    Write-Host "No changes to commit. Working directory clean."
}
