# SystemInteraction

I provide a homogeneous api to execute OS commands or scripts. The api is the same for any of Windows, Linux, Mac operating systems in Pharo.

- [Installation](#installation)
- [Documentation](#documentation)
- [Version management](#version-management)
- [Smalltalk versions compatibility](#smalltalk-versions-compatibility)
- [Contact](#contact)

## Installation

To install the project in your Pharo image execute:

```Smalltalk
    Metacello new
    	githubUser: 'jecisc' project: 'SystemInteraction' commitish: 'v1.x.x' path: 'src';
    	baseline: 'SystemInteraction';
    	load
```

To add it to your baseline:

```Smalltalk
    spec
    	baseline: 'SystemInteraction'
    	with: [ spec repository: 'github://jecisc/SystemInteraction:v1.x.x/src' ]
```

Note that you can replace the #v1.x.x by another branch such as #development or a tag such as #v1.0.0, #v1.? or #v1.1.?.


## Documentation

With this project it is possible to launch commands in different ways.

### Blocking commands

If you want a blocking command returning the result of the command:

```Smalltalk
SICommand waitForCommand: 'ls'
```

You can add arguments:

```Smalltalk
SICommand waitForCommand: 'ls' arguments: { '-h'. '-l' }
```

You can also want you command to be a blocking command but to not care about the stdout of the command:

```Smalltalk
SICommand waitForCommand: 'ls' silently: true.
SICommand waitForCommand: 'ls' arguments: { '-h'. '-l' } silently: true
```

### Non blocking commands

If you want a non blocking command:

```Smalltalk
SICommand executeCommand: 'open'
```

You can add arguments:

```Smalltalk
SICommand waitForCommand: 'mkdir' arguments: { 'testDir' }
```

### Execute a script

It is possible to execute a script in two ways:
- If you have a file, you can execute it via `SICommand class>>#executeScriptFile:silently:`
- If you just have the script in the form of a text, you can execute it via `SICommand class>>#executeScript:silently:`

### Utilities

This project also contains some utilities such has:
- Copying a folder to another using a system command
- Deleting a folder using a system command
- Unzipping a zip archive
- Creating a zip archive

```Smalltalk
dir := 'testDir' asFileReference.
dir ensureCreateDirectory.

(dir / 'test1.txt') ensureCreateFile.
(dir / 'test2.txt') ensureCreateFile.
(dir / 'test3.txt') ensureCreateFile.
(dir / 'test4.txt') ensureCreateFile.

dir2 := 'destination' asFileReference.
dir2 ensureCreateDirectory.

SICommand default copyAll: dir to: dir2.

SICommand default deleteAll: dir.
SICommand default deleteAll: dir2.


ZnClient new
	url: 'https://github.com/jecisc/SystemInteraction/archive/master.zip';
	downloadTo: 'master.zip'.
	

zip := 'master.zip' asFileReference.
unzipped := 'unzipDest' asFileReference.

SICommand default unzip: zip asFileReference to: unzipped.

SICommand default zip: { unzipped } to: 'testArchive.zip'.


SICommand default deleteAll: zip.
SICommand default deleteAll: unzipped.
SICommand default deleteAll: 'testArchive.zip'.
```

More might comes in the future.

## Version management 

This project use semantic versioning to define the releases. This means that each stable release of the project will be assigned a version number of the form `vX.Y.Z`. 

- **X** defines the major version number
- **Y** defines the minor version number 
- **Z** defines the patch version number

When a release contains only bug fixes, the patch number increases. When the release contains new features that are backward compatible, the minor version increases. When the release contains breaking changes, the major version increases. 

Thus, it should be safe to depend on a fixed major version and moving minor version of this project.

## Smalltalk versions compatibility

| Version 	| Compatible Pharo versions 		|
|-------------	|---------------------------	|
| 1.x.x       	| Pharo 61, 70, 80				|

## Contact

If you have any questions or problems do not hesitate to open an issue or contact cyril (a) ferlicot.me 
