; ==== CONFIG ====
nircmd := "C:\nircmd-x64\nircmd.exe"
app := "discord.exe"
step := 0.05        ; 0.05 = 5%. 0.01–0.10 — нормальный диапазон.

; ==== HOTKEYS ====

; Увеличение громкости (LC(LA(UP)))
^!Up:: {
    Run(nircmd " changeappvolume " app " " step)
}

; Уменьшение громкости (LC(LA(DOWN)))
^!Down:: {
    Run(nircmd " changeappvolume " app " -" step)
}
