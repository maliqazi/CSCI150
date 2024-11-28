.386
option	casemap : none
.model flat, stdcall
include C:\masm32\windows.inc
include C:\masm32\user32.inc
include C:\masm32\kernel32.inc
includelib User32.lib
includelib kernel32.lib

WinMain proto :DWORD,:DWORD, :DWORD, :DWORD

.data
	AppName		db	"Home Control System", 0
	ClassName	db	"Class of GUI", 0
	ButtonClass	db	"button", 0
	ButtonText	db	"Garage Open/Close", 0

.data?
	hInstance	HINSTANCE ?
	CommandLine LPSTR	?
	hwndButton	HWND	?

.const
	ButtonID	equ		1

.code
start:
	invoke	GetModuleHandle, 0
	mov		hInstance, eax

	invoke	GetCommandLine
	mov		CommandLine, eax

	invoke	WinMain, hInstance, 0, CommandLine, SW_SHOWDEFAULT
	invoke  ExitProcess, eax

WinMain	proc	hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD

	local	wc:WNDCLASSEX
	local	hwnd:HWND
	local	msg:MSG

	mov		wc.cbSize, SIZEOF WNDCLASSEX
	mov		wc.style, CS_HREDRAW or CS_VREDRAW
	mov		wc.lpfnWndProc, offset WndProc
	mov		wc.hbrBackground, COLOR_BTNFACE+1
	push	hInst
	pop		wc.hInstance
	mov		wc.lpszMenuName, 0
	mov		wc.lpszClassName, offset ClassName
	invoke	LoadIcon, 0, IDI_APPLICATION
	mov		wc.hIcon, eax
	mov		wc.hIconSm, eax
	invoke	LoadCursor, 0, IDC_ARROW
	mov		wc.hCursor, eax
	invoke	RegisterClassEx, addr wc
	invoke	CreateWindowEx, 0, \
		addr ClassName, \
		addr AppName, \
		WS_OVERLAPPEDWINDOW, \
		CW_USEDEFAULT, \
		CW_USEDEFAULT, \
		300, \
		500, \
		0, \
		0, \
		hInst, \
		0

	mov		hwnd, eax

	invoke	ShowWindow, hwnd, CmdShow
	invoke	UpdateWindow, hwnd

	.WHILE 1
		invoke GetMessage, addr msg, 0, 0, 0
	.BREAK	.IF (!eax)
		invoke	TranslateMessage, addr msg
		invoke	DispatchMessage, addr msg
	.ENDW
	mov		eax, msg.wParam

	RET
WinMain		endp

WndProc	proc	hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
.if		uMsg==WM_DESTROY
	invoke	PostQuitMessage, 0

.elseif		uMsg==WM_CREATE
	invoke	CreateWindowEx, 0, addr ButtonClass, addr ButtonText, \
	WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, \
	170, 100, 140, 25, hWnd, ButtonID, hInstance, 0

.else
	invoke	DefWindowProc, hWnd, uMsg, wParam, lParam
	ret
	.endif
	xor		eax, eax
	RET
WndProc endp
end start