# Copy-ScriptsToRepository.ps1
Copy all files from a source directory and it's sub-directories to a target directory.

##Description
This script copies files (.ps1, .cmd, .xml) from your scripts to a new target while persisting the directory structure.

The intention is to copy files from a script development or administrative system to a central (UNC based) file repository.

*.log files are excluded from being copied to the target directory.

Only new files and files changed during the last 180 days are copied. 

##Paramaters
### Source
Source directory containing all files that need to be copied

### Destination
Destination directory

### Overwrite
Overwrite target file, if already exists


##Examples
```
.\Copy-ScriptsToRepository
```
Copy all files using the parameter default

```
.\Copy-ScriptsToRepository -Source f:\Scripts -Destination \\MYSERVER\Scripts
```
Copy files from a dedicated source to a different destination folder

## Note
THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

##TechNet Gallery
Find the script at TechNet Gallery
* 


##Credits
Written by: Thomas Stensitzki

Stay connected:

* My Blog: http://justcantgetenough.granikos.eu
* Twitter: https://twitter.com/stensitzki
* LinkedIn:	http://de.linkedin.com/in/thomasstensitzki
* Github: https://github.com/Apoc70

For more Office 365, Cloud Security and Exchange Server stuff checkout services provided by Granikos

* Blog: http://blog.granikos.eu/
* Website: https://www.granikos.eu/en/
* Twitter: https://twitter.com/granikos_de