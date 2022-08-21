#Persistent
CoordMode, Mouse, Screen

; The shortcut to the game
global gameShortcut = A_WorkingDir . "\gw2.lnk"
global previousMousePositionX := 0
global previousMousePositionY := 0

RunScriptSetup()

~RButton:: SavePreviousMousePosition()
~RButton Up:: SetMousePositionToPreviousPosition()

RunScriptSetup()
{
    try
    {
        FileGetShortcut, %gameShortcut%, fileLocation,,,,, iconNumber
        ; Set the icon of the script
        Menu, Tray, Icon, %fileLocation%, %iconNumber%, 1
        ; Launch the game. NOTE: this hardcoded process name might not work in all cases? I am not sure...
        Process, Exist, "Gw2-64.exe"
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
    IfWinNotActive, Guild Wars 2
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