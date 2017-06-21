<#
  .SYNOPSIS
  Copy all files from a source directory and it's sub-directories to a target directory. 
   
  Author: Thomas Stensitzki
	
  THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE 
  RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
	
  Version 1.1, 2017-06-21

  Please send ideas, comments and suggestions to support@granikos.eu 
 
  .LINK  
  More information can be found at http://www.granikos.eu/en/scripts 
	
  .DESCRIPTION
	
  This script copies files (.ps1, .cmd, .xml) to a new target while persisting the directory structure

  .NOTES 
  Requirements 
  - PowerShell  

  Revision History 
  -------------------------------------------------------------------------------- 
  1.0 Initial community release
  1.1 Filter attribute changed from LastAccessTime to LastWriteTime 
	
  .PARAMETER Source
  Source directory contaiing all files thatneed to be copied

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

[CmdletBinding()]
Param(
  [string]$Source = 'D:\AutomatedServices\Exchange-Skripte\',  
  [string]$Destination = '\\bdr.de\daten\Medien\Software\Freigegeben\Lizenzpflichtig\microsoft\exchange\Scripts\',
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
$includes = "*.ps1*","*.cmd","*.xml"

# Do *NOT* copy the followig files
$excludes = "*.log"

# Fetch files that need to be copie
$items = Get-ChildItem $Source -Recurse -Include $includes -Exclude $excludes | Where-Object {$_.LastWriteTime –gt $since}

Write-Verbose "$($items.Count) files found"

foreach ($item in $items) {
    Write-Verbose "Working on: $($item.FullName)"
    $dir = $item.DirectoryName.Replace($Source,$Destination)
    $target = $item.FullName.Replace($Source,$Destination)

    # Create target directory, if not exists
    if (!(Test-Path($dir))) { 
        Write-Verbose "Creating destination folder: $($dir)"
        mkdir $dir | Out-Null
    }

    # Copy files
    if (!(Test-Path($target))) {
        Write-Verbose "Copy: $($item.FullName)"
        Copy-Item -Path $item.FullName -Destination $target -Recurse -Force | Out-Null
    }
    else {
        if($Overwrite) {
            Write-Verbose "Overwrite: $($item.FullName)"
            Copy-Item -Path $item.FullName -Destination $target -Recurse -Force | Out-Null
        }
        else {
            Write-Verbose "Skip: $($item.FullName)"
        }
    }
}