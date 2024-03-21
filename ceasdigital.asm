.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
includelib canvas.lib
includelib kernel32.lib

extern exit: proc
extern malloc: proc
extern memset: proc
extern BeginDrawing: proc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date

SYSTEMTIME struct
	wYear dw 0
	wMonth dw 0
	wDayOfWeek dw 0
	wDay dw 0
	wHour dw 0
	wMinute dw 0
	wSecond dw 0
	wMillisecond dw 0
SYSTEMTIME ends

sys_time SYSTEMTIME {0, 0, 0, 0, 0, 0, 0, 0}

window_title DB "Exemplu proiect desenare",0
area_width EQU 710
area_height EQU 250
area DD 0

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

spliting_point_x_a EQU 245
spliting_point_x_b EQU 465
spliting_point_y_a EQU 100
spliting_point_y_b EQU 150
spliting_point_line_length EQU 3

seven_segment_length equ 75
seven_segment_digit_a_x dd 50,145,270,365,490,585
seven_segment_digit_a_y dd 6 dup(50)
seven_segment_digit_b_x dd 125,220,345,440,565,660
seven_segment_digit_b_y dd 6 dup(50)
seven_segment_digit_c_x dd 125,220,345,440,565,660
seven_segment_digit_c_y dd 6 dup(125)
seven_segment_digit_d_x dd 50,145,270,365,490,585
seven_segment_digit_d_y dd 6 dup(200)
seven_segment_digit_e_x dd 50,145,270,365,490,585
seven_segment_digit_e_y dd 6 dup(125)
seven_segment_digit_f_x dd 50,145,270,365,490,585
seven_segment_digit_f_y dd 6 dup(50)
seven_segment_digit_g_x dd 50,145,270,365,490,585
seven_segment_digit_g_y dd 6 dup(125)

draw_digit_functions dd 0 dup(26) 
	; 0-9 are functions for drawing digits from 0 to 9
	; 10-25 is just draw_digit_e (255 / 10 = 25) so we can handle
	; the case where the local time might be incorect
include C:\Users\Legion\OneDrive\Documente\Proiect PLA\include\kernel32.inc

.code
; (x, y) => position = y * width + x 
; Draws line from (x, y) down to (x + line_length, y)
; arg1 - area pointer
; arg2 - x
; arg3 - y
; arg4 - line length
draw_vertical_line proc
	push ebp
	mov ebp, esp
	
	mov eax, [ebp + arg3]
	mov ebx, area_width
	mul ebx
	mov ebx, [ebp + arg2]
	add eax, ebx
	shl eax, 2
	
	mov esi, [ebp + arg1]
	add esi, eax
	mov ecx, [ebp + arg4]
	mov ebx, area_width
	shl ebx, 2
	for_draw_vertical_line:
		mov dword ptr [esi], 0
		add esi, ebx
	loop for_draw_vertical_line
	mov esp, ebp
	pop ebp
	ret
draw_vertical_line endp

; Draws line from (x, y) down to (x, y + line_length)
; arg1 - area pointer
; arg2 - x
; arg3 - y
; arg4 - line length
draw_horizontal_line proc
	push ebp
	mov ebp, esp
	
	mov eax, [ebp + arg3]
	mov ebx, area_width
	mul ebx
	mov ebx, [ebp + arg2]
	add eax, ebx
	shl eax, 2
	
	mov esi, [ebp + arg1]
	add esi, eax
	mov ecx, [ebp + arg4]
	for_draw_horizontal_line:
		mov dword ptr [esi], 0
		add esi, 4
	loop for_draw_horizontal_line
	mov esp, ebp
	pop ebp
	ret
draw_horizontal_line endp

; arg1 - area
; arg2 - which digit (0 to 5)
draw_seven_segment_digit_a proc
	push ebp
	mov ebp, esp
	
	mov eax, [ebp + arg2]
	shl eax, 2
	
	push seven_segment_length
	push dword ptr [seven_segment_digit_a_y + eax]
	push dword ptr [seven_segment_digit_a_x + eax]
	push [ebp + arg1]
	call draw_horizontal_line
	add esp, 16
	
	mov esp, ebp
	pop ebp
	ret
draw_seven_segment_digit_a endp

; arg1 - area
; arg2 - which digit (0 to 5)
draw_seven_segment_digit_b proc
	push ebp
	mov ebp, esp
	
	mov eax, [ebp + arg2]
	shl eax, 2
	
	push seven_segment_length
	push dword ptr [seven_segment_digit_b_y + eax]
	push dword ptr [seven_segment_digit_b_x + eax]
	push [ebp + arg1]
	call draw_vertical_line
	add esp, 16
	
	mov esp, ebp
	pop ebp
	ret
draw_seven_segment_digit_b endp

; arg1 - area
; arg2 - which digit (0 to 5)
draw_seven_segment_digit_c proc
	push ebp
	mov ebp, esp
	
	mov eax, [ebp + arg2]
	shl eax, 2
	
	push seven_segment_length
	push dword ptr [seven_segment_digit_c_y + eax]
	push dword ptr [seven_segment_digit_c_x + eax]
	push [ebp + arg1]
	call draw_vertical_line
	add esp, 16
	
	mov esp, ebp
	pop ebp
	ret
draw_seven_segment_digit_c endp

; arg1 - area
; arg2 - which digit (0 to 5)
draw_seven_segment_digit_d proc
	push ebp
	mov ebp, esp
	
	mov eax, [ebp + arg2]
	shl eax, 2
	
	push seven_segment_length
	push dword ptr [seven_segment_digit_d_y + eax]
	push dword ptr [seven_segment_digit_d_x + eax]
	push [ebp + arg1]
	call draw_horizontal_line
	add esp, 16
	
	mov esp, ebp
	pop ebp
	ret
draw_seven_segment_digit_d endp

; arg1 - area
; arg2 - which digit (0 to 5)
draw_seven_segment_digit_e proc
	push ebp
	mov ebp, esp
	
	mov eax, [ebp + arg2]
	shl eax, 2
	
	push seven_segment_length
	push dword ptr [seven_segment_digit_e_y + eax]
	push dword ptr [seven_segment_digit_e_x + eax]
	push [ebp + arg1]
	call draw_vertical_line
	add esp, 16
	
	mov esp, ebp
	pop ebp
	ret
draw_seven_segment_digit_e endp

; arg1 - area
; arg2 - which digit (0 to 5)
draw_seven_segment_digit_f proc
	push ebp
	mov ebp, esp
	
	mov eax, [ebp + arg2]
	shl eax, 2
	
	push seven_segment_length
	push dword ptr [seven_segment_digit_f_y + eax]
	push dword ptr [seven_segment_digit_f_x + eax]
	push [ebp + arg1]
	call draw_vertical_line
	add esp, 16
	
	mov esp, ebp
	pop ebp
	ret
draw_seven_segment_digit_f endp

; arg1 - area
; arg2 - which digit (0 to 5)
draw_seven_segment_digit_g proc
	push ebp
	mov ebp, esp
	
	mov eax, [ebp + arg2]
	shl eax, 2
	
	push seven_segment_length
	push dword ptr [seven_segment_digit_g_y + eax]
	push dword ptr [seven_segment_digit_g_x + eax]
	push [ebp + arg1]
	call draw_horizontal_line
	add esp, 16
	
	mov esp, ebp
	pop ebp
	ret
draw_seven_segment_digit_g endp

; Draws digit 0
; arg1 - area
; arg2 - which digit (0 to 5)
draw_digit_0 proc
	push ebp
	mov ebp, esp
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_a
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_b
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_c
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_d
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_e
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_f
	add esp, 8
	
	mov esp, ebp
	pop ebp
	ret
draw_digit_0 endp

; Draws digit 1
; arg1 - area
; arg2 - which digit (0 to 5)
draw_digit_1 proc
	push ebp
	mov ebp, esp
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_b
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_c
	add esp, 8
	
	mov esp, ebp
	pop ebp
	ret
draw_digit_1 endp

; Draws digit 2
; arg1 - area
; arg2 - which digit (0 to 5)
draw_digit_2 proc
	push ebp
	mov ebp, esp
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_a
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_b
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_d
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_e
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_g
	add esp, 8
	
	mov esp, ebp
	pop ebp
	ret
draw_digit_2 endp

; Draws digit 3
; arg1 - area
; arg2 - which digit (0 to 5)
draw_digit_3 proc
	push ebp
	mov ebp, esp
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_a
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_b
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_c
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_d
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_g
	add esp, 8
	
	mov esp, ebp
	pop ebp
	ret
draw_digit_3 endp

; Draws digit 4
; arg1 - area
; arg2 - which digit (0 to 5)
draw_digit_4 proc
	push ebp
	mov ebp, esp
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_b
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_c
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_f
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_g
	add esp, 8
	
	mov esp, ebp
	pop ebp
	ret
draw_digit_4 endp

; Draws digit 5
; arg1 - area
; arg2 - which digit (0 to 5)
draw_digit_5 proc
	push ebp
	mov ebp, esp
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_a
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_c
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_d
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_f
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_g
	add esp, 8
	
	mov esp, ebp
	pop ebp
	ret
draw_digit_5 endp

; Draws digit 6
; arg1 - area
; arg2 - which digit (0 to 5)
draw_digit_6 proc
	push ebp
	mov ebp, esp
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_a
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_c
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_d
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_e
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_f
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_g
	add esp, 8
	
	mov esp, ebp
	pop ebp
	ret
draw_digit_6 endp

; Draws digit 7
; arg1 - area
; arg2 - which digit (0 to 5)
draw_digit_7 proc
	push ebp
	mov ebp, esp
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_a
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_b
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_c
	add esp, 8
	
	mov esp, ebp
	pop ebp
	ret
draw_digit_7 endp

; Draws digit 8
; arg1 - area
; arg2 - which digit (0 to 5)
draw_digit_8 proc
	push ebp
	mov ebp, esp
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_a
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_b
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_c
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_d
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_e
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_f
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_g
	add esp, 8
	
	mov esp, ebp
	pop ebp
	ret
draw_digit_8 endp

; Draws digit 9
; arg1 - area
; arg2 - which digit (0 to 5)
draw_digit_9 proc
	push ebp
	mov ebp, esp
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_a
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_b
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_c
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_d
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_f
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_g
	add esp, 8
	
	mov esp, ebp
	pop ebp
	ret
draw_digit_9 endp

; Draws digit error (E)
; arg1 - area
; arg2 - which digit (0 to 5)
draw_digit_error proc
	push ebp
	mov ebp, esp
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_a
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_d
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_e
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_f
	add esp, 8
	
	push [ebp + arg2]
	push [ebp + arg1]
	call draw_seven_segment_digit_g
	add esp, 8
	
	mov esp, ebp
	pop ebp
	ret
draw_digit_error endp

; draw small circle radius 2px
; arg1 - area
; arg2 - circle center x
; arg3 - circle center y
draw_small_circle proc
	push ebp
	mov ebp, esp
	
	mov eax, [ebp + arg3]
	mov ebx, area_width
	mul ebx
	mov ebx, [ebp + arg2]
	add eax, ebx
	shl eax, 2
	
	mov edi, [ebp + arg1]
	add edi, eax
	
	mov dword ptr [edi], 0
	mov dword ptr [edi + 4], 0
	mov dword ptr [edi + 8], 0
	mov dword ptr [edi - 4], 0
	mov dword ptr [edi - 8], 0
	
	push edi
	
	mov eax, area_width
	shl eax, 2
	sub edi, eax
	
	mov dword ptr [edi], 0
	mov dword ptr [edi + 4], 0
	mov dword ptr [edi - 4], 0
	
	sub edi, eax
	
	mov dword ptr [edi], 0
	
	pop edi
	
	add edi, eax
	
	mov dword ptr [edi], 0
	mov dword ptr [edi + 4], 0
	mov dword ptr [edi - 4], 0
	
	add edi, eax
	
	mov dword ptr [edi], 0
	
	mov esp, ebp
	pop ebp
	ret
draw_small_circle endp

; arg1 - area
draw_local_time proc
	push ebp
	mov ebp, esp
	
	push offset sys_time
	call GetLocalTime
	add esp, 4
	
	xor eax, eax
	xor edx, edx
	mov ax, sys_time.wHour
	mov ebx, 10
	div ebx
	
	push eax
	push edx
	
	push 0
	push [ebp + arg1]
	call [draw_digit_functions + eax * 4]
	add esp, 8
	
	pop edx
	pop eax
	
	push 1
	push [ebp + arg1]
	call [draw_digit_functions + edx * 4]
	add esp, 8
	
	xor eax, eax
	xor edx, edx
	mov ax, sys_time.wMinute
	mov ebx, 10
	div ebx
	
	push eax
	push edx
	
	push 2
	push [ebp + arg1]
	call [draw_digit_functions + eax * 4]
	add esp, 8
	
	pop edx
	pop eax
	
	push 3
	push [ebp + arg1]
	call [draw_digit_functions + edx * 4]
	add esp, 8
	
	xor eax, eax
	xor edx, edx
	mov ax, sys_time.wSecond
	mov ebx, 10
	div ebx
	
	push eax
	push edx
	
	push 4
	push [ebp + arg1]
	call [draw_digit_functions + eax * 4]
	add esp, 8
	
	pop edx
	pop eax
	
	push 5
	push [ebp + arg1]
	call [draw_digit_functions + edx * 4]
	add esp, 8
	
	push spliting_point_y_a
	push spliting_point_x_a
	push area
	call draw_small_circle
	add esp, 12
	
	push spliting_point_y_b
	push spliting_point_x_a
	push area
	call draw_small_circle
	add esp, 12
	
	push spliting_point_y_a
	push spliting_point_x_b
	push area
	call draw_small_circle
	add esp, 12
	
	push spliting_point_y_b
	push spliting_point_x_b
	push area
	call draw_small_circle
	add esp, 12
	
	mov esp, ebp
	pop ebp
	ret
draw_local_time endp

; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	
	push eax
	push 255
	push area
	call memset
	add esp, 12	
	
	push area
	call draw_local_time
	add esp, 4
	
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	; init draw_digit_function vector
	lea edi, draw_digit_functions
	mov dword ptr [edi + 0 * 4], offset draw_digit_0
	mov dword ptr [edi + 1 * 4], offset draw_digit_1
	mov dword ptr [edi + 2 * 4], offset draw_digit_2
	mov dword ptr [edi + 3 * 4], offset draw_digit_3
	mov dword ptr [edi + 4 * 4], offset draw_digit_4
	mov dword ptr [edi + 5 * 4], offset draw_digit_5
	mov dword ptr [edi + 6 * 4], offset draw_digit_6
	mov dword ptr [edi + 7 * 4], offset draw_digit_7
	mov dword ptr [edi + 8 * 4], offset draw_digit_8
	mov dword ptr [edi + 9 * 4], offset draw_digit_9
	
	mov ecx, 10
	for_draw_digit_functions_init:
		mov dword ptr [edi + ecx * 4], offset draw_digit_error
		inc ecx
	cmp ecx, 26
	jl for_draw_digit_functions_init

	; allocate memory for drawing area
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	; call window drawing function
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	push 0
	call exit
end start
