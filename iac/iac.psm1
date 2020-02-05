$projectRoot = Resolve-Path "$PSScriptRoot\.."
$sourceRoot = [System.IO.Path]::Combine($PSScriptRoot, "iac")
$sourceRoot = $projectRoot

Write-Verbose "Importing Functions"

# Import everything in these folders private
$privateRoot = [System.IO.Path]::Combine($sourceRoot, "iac", "private")
$files = Get-ChildItem -Path $privateRoot -Filter *.ps1

$files | ForEach-Object{Write-Verbose $_.name; . $_.FullName}

# Import everything in these folders public
$publicRoot = [System.IO.Path]::Combine($sourceRoot, "iac", "public")
$files = Get-ChildItem -Path $publicRoot -Filter *.ps1
Write-Host $files
$files | ForEach-Object{Write-Verbose $_.name; . $_.FullName}
