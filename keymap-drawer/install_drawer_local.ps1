# py -m pip uninstall --user pipx
python -m pip install --user pipx
python -m pipx ensurepath
# pipx uninstall keymap-drawer
python -m pipx install keymap-drawer
& "$env:USERPROFILE\pipx\venvs\keymap-drawer\Scripts\python.exe" -m pip uninstall tree-sitter -y
& "$env:USERPROFILE\pipx\venvs\keymap-drawer\Scripts\python.exe" -m pip install tree-sitter==0.24.0
& "$env:USERPROFILE\pipx\venvs\keymap-drawer\Scripts\python.exe" -m pip show tree-sitter
