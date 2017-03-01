<#
  .SYNOPSIS
  Copy all files from a source directory and it's sub-directories to a target directory. 
   
  Author: Thomas Stensitzki
	
  THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE 
  RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
	
  Version 1.0, 2017-03-01

  Please send ideas, comments and suggestions to support@granikos.eu 
 
  .LINK  
  http://scripts.granikos.eu 
	
  .DESCRIPTION
	
  This script copies files (.ps1, .cmd, .xml) to a new target while persisting the directory structure.

  *.log files are excluded from being copied to the target directory.

  Only new files and files changed during the last 180 days are copied. 

  .NOTES 
  Requirements 
  - PowerShell  

  Revision History 
  -------------------------------------------------------------------------------- 
  1.0     Initial community release 
	
  .PARAMETER Source
  Source directory containing all files that need to be copied

  .PARAMETER Destination
  Destination directory

  .PARAMETER Overwrite
  Overwrite target file, if already exists

  .EXAMPLE
  Copy all files using the parameter default
  .\Copy-ScriptsToRepository

  .EXAMPLE
  Copy files from a dedicated source to a different destination folder
  .\Copy-ScriptsToRepository -Source f:\Scripts -Destination \\MYSERVER\Scripts

#>

Param(
  [CmdletBinding]
  # Set default value to your preferred source location
  [parameter()]
  [string]$Source = "$env:HOMEDRIVE\Scripts",   
  # Set default value to your preferred targetlocation
  [parameter()]
  [string]$Destination = '\\MYFILESERVER\SharedScripts\Scripts\',
  [parameter()]
  [switch]$Overwrite
)

# ensure trailing \
if(!($Source.EndsWith('\'))) {$Source = $Source +'\'}
if(!($Destination.EndsWith('\'))) {$Destination = $Destination +'\'}

Write-Output "Copy from: $($Source)"
Write-Output "Copy to  : $($Destination)"

# Copy files that have changed during the last 180 days
$since = (Get-Date).AddDays(-180)

# Copy only files having the following file extensions
$includes = '*.ps1*','*.cmd','*.xml'

# Do *NOT* copy the followig files
$excludes = '*.log'

# Fetch files that need to be copie
$items = Get-ChildItem -Path $Source -Recurse -Include $includes -Exclude $excludes | Where-Object {$_.LastAccessTime -gt $since}

Write-Verbose -Message "$($items.Count) files found"

foreach ($item in $items) {
    Write-Verbose -Message "Working on: $($item.FullName)"
    $dir = $item.DirectoryName.Replace($Source,$Destination)
    $target = $item.FullName.Replace($Source,$Destination)

    # Create target directory, if not exists
    if (!(Test-Path -Path ($dir))) { 
        Write-Verbose -Message "Creating destination folder: $($dir)"
        mkdir -Path $dir | Out-Null
    }

    # Copy files
    if (!(Test-Path -Path ($target))) {
        Write-Verbose -Message "Copy: $($item.FullName)"
        Copy-Item -Path $item.FullName -Destination $target -Recurse -Force | Out-Null
    }
    else {
        if($Overwrite) {
            Write-Verbose -Message "Overwrite: $($item.FullName)"
            Copy-Item -Path $item.FullName -Destination $target -Recurse -Force | Out-Null
        }
        else {
            Write-Verbose -Message "Skip: $($item.FullName)"
        }
    }
}