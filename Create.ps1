Param(
    [Parameter(Mandatory = $True)]
    [string] $solutionName,

    # [string] $controllerName = "Value",

    [string] $sourceDir = ".\Template\",

    [switch] $deleteExistingDirectory = $False  
)

$targetDir = ".\$solutionName"

$sourceSolutionName = "SeedProject"
$fullSourceSolutionName = "SeedProject"
$fullSourceSolutionNameLowerCase = $fullSourceSolutionName.ToLower()
$fullSolutionName = $solutionName
$fullSolutionNameLowerCase = $fullSolutionName.ToLower()

# $sourceControllerName = "Example"
# $sourceControllerNameLowerCase = "exampleItem"
# $controllerNameLowerCase = $controllerName.substring(0,1).ToLower()+$controllerName.substring(1)

Write-Host "Target directory is: $targetDir"

if (Test-Path $targetDir) {

    if ($deleteExistingDirectory) {
        Write-Host "Deleting: $targetDir"
        Remove-Item $targetDir -recurse
    }
    else {
        Write-Host "The target directory already exists, you can force deletion with the -deleteExistingDirectory flag"
        exit
    }
}

# Copy the source directory to the new directory recursively
Write-Host "Creating the new project from the source"
New-Item -ItemType directory -Path $targetDir | Out-Null
Get-ChildItem -Path $sourceDir | Copy-Item -Destination $targetDir -recurse 
Write-Host "New project is copied"

# Rename the files and folders for the solution
Write-Host "Renaming the files of the solution to: $fullSolutionName"
Get-ChildItem -Path $targetDir -filter "$fullSourceSolutionName*" -recurse | 
    ForEach-Object {
        Rename-Item -Path $_.FullName -NewName ($_.name -replace $fullSourceSolutionName, $fullSolutionName)
    }
Get-ChildItem -Path $targetDir -filter "$sourceSolutionName*" -recurse | 
    ForEach-Object {
        Rename-Item -Path $_.FullName -NewName ($_.name -creplace $sourceSolutionName, $solutionName)
    }
Write-Host "Renaming the files of the solution complete"

# Replace the contents of the files with the new solution name
Write-Host "Renaming the contents of the files in the solution to use the new solution name"
Get-ChildItem -Path $targetDir -File -recurse | 
    ForEach-Object {
        (Get-Content $_.FullName) | 
            ForEach-Object {
                $_ -creplace ($fullSourceSolutionName, $fullSolutionName) -creplace ($fullSourceSolutionNameLowerCase, $fullSolutionNameLowerCase)
            } | 
            Set-Content $_.FullName
    }
Get-ChildItem -Path $targetDir -File -recurse | 
    ForEach-Object {
        (Get-Content $_.FullName) | 
            ForEach-Object {
                $_ -creplace ($sourceSolutionName, $solutionName) -creplace ($sourceSolutionNameLowerCase, $solutionNameLowerCase)
            } | 
            Set-Content $_.FullName
    }
Write-Host "Renaming the contents of the files in the solution complete"

# # If the user specified the controllerName parameter then let's change the controller value in the seed
# if ($PSBoundParameters.ContainsKey('controllerName')) {
    # # Rename the files and folders for the controller
    # Write-Host "Renaming the files of the controller to: $controllerName"
    # Get-ChildItem -Path $targetDir -filter "*$sourceControllerName*" -recurse | 
        # ForEach-Object {
            # Rename-Item -Path $_.FullName -NewName ($_.name -replace $sourceControllerName, $controllerName)
        # }
     
    # # Replace the contents of the files with the new controller name
    # Write-Host "Renaming the contents of the files in the solution to use the new controller name"
    # Get-ChildItem -Path $targetDir -File -recurse | 
        # ForEach-Object {
            # (Get-Content $_.FullName) | 
                # ForEach-Object {
                    # $_ -creplace ($sourceControllerName, $controllerName) -creplace ($sourceControllerNameLowerCase, $controllerNameLowerCase)
                # } | 
                # Set-Content $_.FullName
        # } 
# }
