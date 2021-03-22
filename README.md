# auto-compiler
An automatic compiler that compiles your `.lyx` files according to your needs.

## Usage
 - Set your `UNI` environment variable to wherever your `.lyx` files are located.
 - Clone this repository.
 - Copy the `compilation.config` file into `%UNI%` and edit it to your needs.
 - Create a shortcut to `AutoCompiler.bat`.
 - Open `Run` and enter `shell:startup` and place the shortcut in the folder.

### Configuration file
A valid configuration file must include the following:
 - an `enabled` property: `true` if you wish the program to run on startup and `false` otherwise.
 - an `engine` property: `pdflatex` or `xelatex` according to your needs. **Only `pdflatex` and `xelatex` are currently supported**
 - a `conflicts` property: `weak` if you wish the compilation to stop when it meets a conflict with the remote repository associated with the `%UNI%` folder. `force` if the compilation should continue even when the remote is ahead of the local repository. `disabled` if git is not initialized in `%UNI%`.
 - All the subfolders of `%UNI%` that you wish to have they LyX files in them compiled.
## Requirements
Windows 10