@echo off
setlocal EnableDelayedExpansion
choice /c yn /n /m "Do you wish to recompile your pdfs? (y/n)"
:: if the answer is not yes (Y), jump to end
if %ERRORLEVEL%==2 goto END
:: Check if Uni path environment variable exists
if not defined UNI (
	choice /c yn /n /m "UNI environment variable undefined, do you wish to manually input a path? (y/n)"
	:: If the user doesn't want to manually folder, jump to end
	if %ERRORLEVEL%==2 goto END
	set /p UNI="Enter uni folder path: "
)
cd %UNI%
:: Open configurations file in Uni path to locate wanted .lyx files
for /f "tokens=1* delims==" %%i in (./compilation.config) do (
	:: Check if to parse enabled propert
	if %%i==enabled (
		:: if config says not to run it
		if not %%j==true (
			echo Enabled property false. Exiting AutoCompiler...
			goto END
		)
	) else (
	:: Check if to parse engine property
	if %%i==engine (
		if %%j==xelatex set engine=pdf4
		if %%j==pdflatex set engine=pdf2
		:: If no valid engine was found, exit the program
		if not defined engine (
			echo Engine property invalid. Exiting AutoCompiler...
			goto END
		)
		echo Using %%j...
	) else (
	if %%i==conflicts (
		if %%j==weak (
			for /f  %%l in ('git rev-list --left-only --count origin/master...master') do if not %%l==0 (
				echo Unmerged commits from remote repository available. Exiting AutoCompiler...
				goto END
			)
		)
	) else (
		:: Declate the current folder
		set "folder=%%i"
		echo !folder!:
		:: Go over each file in the folder
		for %%f in (.\"!folder!"\*.lyx) do (
			:: Check if it's really a ./lyx file
			echo "%%f"
			if "%%~xf"==".lyx" (
				set "file=%%f"
				:: Derive the name of the pdf file
				set "pdf=!file:~0,-3!pdf"
				:: Check if the matching pdf exists
				if exist !pdf! (
					echo|set /p=Deleting "!pdf!"...
					:: Delete the previous pdf if it exists
					del "!pdf!"
					echo. Done.
				)
				echo|set /p=Compiling "!file!"...
				:: Export the .lyx file using xelatex
				lyx --export !engine! "!file!"
				echo. Done.
			)
		)
	)
		)
	)
)
:END
Pause