@echo off

taskkill /F /IM werl.exe
start werl -args_file vm.args
