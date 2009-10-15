@echo off

rem plcon.exe -f none -F none -g true -t "consult(['%2']),qsave_program('aiprg.exe',[goal='\$welcome',toplevel=prolog,init_file=none])"

plcon.exe -t "consult(['%2']),qsave_program('aiprg.exe')"
copy /b %1+aiprg.exe %3
del aiprg.exe
