pac solution export --path ./solution.zip --name DiscrepancyManagement --managed false
pac solution unpack --zipfile ./solution.zip --folder ./src/Solution --packagetype Unmanaged

git add .
git commit -m "Update solution"
git push