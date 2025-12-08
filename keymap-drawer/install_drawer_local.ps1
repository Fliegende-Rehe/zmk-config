# py -m pip uninstall --user pipx
py -m pip install --user pipx
pipx ensurepath
# pipx uninstall keymap-drawer
pipx install keymap-drawer
& "$env:USERPROFILE\pipx\venvs\keymap-drawer\Scripts\python.exe" -m pip uninstall tree-sitter -y
& "$env:USERPROFILE\pipx\venvs\keymap-drawer\Scripts\python.exe" -m pip install tree-sitter==0.24.0
& "$env:USERPROFILE\pipx\venvs\keymap-drawer\Scripts\python.exe" -m pip show tree-sitter
