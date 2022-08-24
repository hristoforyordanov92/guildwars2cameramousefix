#Persistent
CoordMode, Mouse, Screen

; The shortcut to the game
global gameShortcut = A_WorkingDir . "\gw2.lnk"
global previousMousePositionX := 0
global previousMousePositionY := 0
global gameProcessName := "Gw2-64.exe"
global gameWindowName := "Guild Wars 2"

RunScriptSetup()
; sleep just in case. works without it though
Sleep, 500
Process, WaitClose, %gameProcessName%
ExitApp

~RButton:: SavePreviousMousePosition()
~RButton Up:: SetMousePositionToPreviousPosition()

RunScriptSetup()
{
    try
    {
        ; TODO: ask the user to find the executable when there's no gw2.lnk file next to the script. then create it automatically
        ; TODO: ask to create a shortcut on user's desktop
        
        FileGetShortcut, %gameShortcut%, fileLocation,,,,, iconNumber
        ; Set the icon of the script
        Menu, Tray, Icon, %fileLocation%, %iconNumber%, 1
        ; Launch the game. NOTE: this hardcoded process name might not work in all cases? I am not sure...
        Process, Exist, %gameProcessName%
        if ErrorLevel = 0
            Run, %gameShortcut%
    }
    catch
    {
    }
}

SavePreviousMousePosition()
{
    MouseGetPos, previousMousePositionX, previousMousePositionY
}

SetMousePositionToPreviousPosition()
{
    IfWinNotActive, %gameWindowName%
    {
        return
    }
    
    BlockInput, MouseMove
    
    ; There might be a more graceful way to set the mouse, but it works OK for now and I'm too lazy to change it.
    Loop, 10
    {
        Sleep, 20
        MouseMove, previousMousePositionX, previousMousePositionY, 0
        
        Sleep, 10
        MouseGetPos, currentCursorPositionX, currentCursorPositionY
        if (currentCursorPositionX = previousMousePositionX AND currentCursorPositionY = previousMousePositionY)
        {
            break
        }
    }
    
    BlockInput, MouseMoveOff
}