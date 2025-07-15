# Export Power Platform solution and push to GitHub
# Solution: DiscrepancyManagement
# Branch: master

$solutionName = "DiscrepancyManagement"
$zipFile = "./solution.zip"
$unpackFolder = "./src/Solution"
$gitBranch = "master"

# Remove old zip if exists
if (Test-Path $zipFile) {
    Remove-Item $zipFile
}

Write-Host "Pulling latest from GitHub branch '$gitBranch'..."
git pull --rebase origin $gitBranch

Write-Host "Exporting solution '$solutionName'..."
pac solution export --path $zipFile --name $solutionName --managed false

Write-Host "Unpacking solution to '$unpackFolder'..."
pac solution unpack --zipfile $zipFile --folder $unpackFolder --packagetype Unmanaged

Write-Host "Adding changes to Git..."
git add .

$timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$commitMessage = "Update DiscrepancyManagement solution: $timeStamp"

Write-Host "Committing changes..."
git commit -m "$commitMessage"

Write-Host "Pushing to branch '$gitBranch'..."
git push -u origin $gitBranch

Write-Host "Done."
