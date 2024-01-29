;Abdul Moiz Sarwar & Ahmad Mujtaba
[org 0x0100]
jmp start
;data
gamename: db' CATCH to SCORE '
developers: db 'Developed by Abdul Moiz and Ahmad Mujtaba'
instruction1: db'RULES & REQUIREMENTS'
instruction2: db 'Player has a total time of 2 minutes'
instruction3: db 'Move left using <- Key and Move right using -> Key'
instruction4: db ' Press ENTER to start '
instruction5: db 'Your total score was: '
instruction6: db ' Press ENTER to start again '
score: dd 0
time: dw 120
timer: dw 0
bxc: dw 40
c1x: dw 0
c1y: dw 0
c2x: dw 0
c2y: dw 0
c3x: dw 0
c3y: dw 0
box: dw 0
boy: dw 0
counter: dw 0;
;start
start:
call startingscreen

mov word[counter], 0
mov word[bxc], 40
mov word[score], 0
mov word[c1x], 10
mov word[c1y], 10
mov word[c2x], 20
mov word[c2y], 20
mov word[c3x], 5
mov word[c3y], 5
mov word[box], 15
mov word[boy], 15
mov word[time], 120
mov word[timer], 0

gamestart:


forever:
;start inputs

;clear input
mov al, 0
out 0x60, al

;take input
in al, 0x60
;save bx
push bx
;check left move
cmp al, 0x4B
jne dontmoveleft
mov bx,[bxc]
cmp bx, 3
jbe dontmoveleft
dec bx
mov word[bxc], bx
dontmoveleft:

;check right move
cmp al, 0x4D
jne dontmoveright
mov bx,[bxc]
cmp bx, 76
jae dontmoveright
inc bx
mov word[bxc], bx
dontmoveright:

;load bx back
pop bx

;check quit key
cmp al, 0x10
je gameover


;check timer
cmp word[time], 0
je gameover

inc word[timer]
;decrease time
cmp word[timer], 135
jb dontdecreasetime
dec word[time]
mov word[timer], 0
dontdecreasetime:

;print frame
call background
call printtimer
call printscore
call bucket
call coin1
call coin2
call coin3
call bomb
call delay1sec
;end inputs

;check and update frame
inc word[counter]
cmp word[counter], 20
jne	waitforframe
mov word[counter], 0
inc word[c1y]
inc word[c2y]
inc word[c3y]
inc word[boy]
waitforframe:


;check if items reached ground, then move up
;coin1
cmp word[c1y], 19
jbe dontresetc1
mov word[c1y], 0
;getting a random x coordinate
push ax
push bx
push cx
push dx
rdtsc
mov dx, 0
mov cx, 76
div cx
add dx, 2
mov word[c1x], dx
pop dx
pop cx
pop bx
pop ax
dontresetc1:

;coin2
cmp word[c2y], 19
jbe dontresetc2
mov word[c2y], 0
;getting a random x coordinate
push ax
push bx
push cx
push dx
rdtsc
mov dx, 0
mov cx, 76
div cx
add dx, 2
mov word[c2x], dx
pop dx
pop cx
pop bx
pop ax
dontresetc2:

;coin3
cmp word[c3y], 19
jbe dontresetc3
mov word[c3y], 0
;getting a random x coordinate
push ax
push bx
push cx
push dx
rdtsc
mov dx, 0
mov cx, 76
div cx
add dx, 2
mov word[c3x], dx
pop dx
pop cx
pop bx
pop ax
dontresetc3:

;bomb
cmp word[boy], 19
jbe dontresetbomb
mov word[boy], 0
;getting a random x coordinate
push ax
push bx
push cx
push dx
rdtsc
mov dx, 0
mov cx, 76
div cx
add dx, 2
mov word[box], dx
pop dx
pop cx
pop bx
pop ax
dontresetbomb:

;check if item hits bucket
;coin 1
cmp word[c1y], 17
jne coin1nottouch
mov ax, word[bxc]
dec ax
cmp word[c1x], ax
jb	coin1nottouch
add ax, 2
cmp word[c1x], ax
ja	coin1nottouch
mov word[c1y], 0
;getting a random x coordinate
push ax
push bx
push cx
push dx
rdtsc
mov dx, 0
mov cx, 76
div cx
add dx, 2
mov word[c1x], dx
pop dx
pop cx
pop bx
pop ax
add word[score], 5
adc word[score + 2], 0
coin1nottouch:

;coin 2
cmp word[c2y], 17
jne coin2nottouch
mov ax, word[bxc]
dec ax
cmp word[c2x], ax
jb	coin2nottouch
add ax, 2
cmp word[c2x], ax
ja	coin2nottouch
mov word[c2y], 0
;getting a random x coordinate
push ax
push bx
push cx
push dx
rdtsc
mov dx, 0
mov cx, 76
div cx
add dx, 2
mov word[c2x], dx
pop dx
pop cx
pop bx
pop ax
add word[score], 10
adc word[score + 2], 0
coin2nottouch:

;coin 3
cmp word[c3y], 17
jne coin3nottouch
mov ax, word[bxc]
dec ax
cmp word[c3x], ax
jb	coin3nottouch
add ax, 2
cmp word[c3x], ax
ja	coin3nottouch
mov word[c3y], 0
;getting a random x coordinate
push ax
push bx
push cx
push dx
rdtsc
mov dx, 0
mov cx, 76
div cx
add dx, 2
mov word[c3x], dx
pop dx
pop cx
pop bx
pop ax
add word[score], 15
adc word[score + 2], 0
coin3nottouch:

;bomb
cmp word[boy], 17
jne bombnottouch
mov ax, word[bxc]
dec ax
cmp word[box], ax
jb	bombnottouch
add ax, 2
cmp word[box], ax
ja	bombnottouch
jmp gameover
bombnottouch:

jmp forever

gameover:
call endingscreen
;clear input
mov al, 0
out 0x60, al
playagain:
in al, 0x60
cmp al, 0x1C
je start
cmp al, 0x10
je endgame	
jmp playagain
endgame:
mov ax, 0x4c00
int 0x21

;functions




delay2secs:
push ax
push bx
mov ax, 1000
nextax2:
mov bx, 2000
nextbx2:
sub bx, 1
jnz nextbx2
sub ax, 1
jnz nextax2
pop bx
pop ax
ret

delay1sec:
push ax
push bx
mov ax, 100
nextax1:
mov bx, 100
nextbx1:
sub bx, 1
jnz nextbx1
sub ax, 1
jnz nextax1
pop bx
pop ax
ret
;printing time
printtimer:
push ax
push bx
push es
push di

mov ax, 0xB800
mov es, ax

mov di, 14
mov bx, 0

mov bx, 10
mov cx, 0
mov ax, [time]
dividetimeagain:
mov dx, 0
div bx
add dl, 48
push dx
inc cx
cmp ax, 0
jnz dividetimeagain

printtimeagain:
pop ax
mov ah, 0x0F
mov word[es:di], ax
add di, 2
loop printtimeagain

pop di
pop es
pop bx
pop ax
ret

;printing score
printscore:
push ax
push bx
push cx
push dx
push es
push di

mov di, 152
mov ax, 0xB800
mov es, ax

mov bx, 10
mov cx, 0
mov ax, [score]
divideagain:
mov dx, 0
div bx
add dl, 48
push dx
inc cx
cmp ax, 0
jnz divideagain

printscoreagain:
pop ax
mov ah, 0x0F
mov word[es:di], ax
add di, 2
loop printscoreagain

pop di
pop es
pop dx
pop cx
pop bx
pop ax
ret





;bomb
bomb:
push ax
push es
push di
push cx
cld
mov ax, 0xB800
mov es, ax
mov al, 80	
mul byte[boy]	;get y coordinates
mov di, ax
add di, [box]	;get x coordinates
shl di, 1
;set starting value
sub di, 4
sub di, 160
;top left and right
mov ax, 0x4FC5
mov word[es:di], ax
add di, 8
mov word[es:di], ax
sub di, 6
;top
mov ax, 0x4FC4
mov cx, 3
rep stosw
sub di, 8
add di, 320
;sides
mov ax, 0x4FC5
mov word[es:di], ax
add di, 8
mov word[es:di], ax
sub di, 6
;bottom
mov ax, 0x4FC4
mov cx, 3
rep stosw
;bottom right and left
sub di, 160
mov ax, 0x4FB3
mov word[es:di], ax
sub di, 8
mov word[es:di], ax
;TNT
add di, 2
mov ax, 0x4F54
mov word[es:di], ax
add di, 4
mov word[es:di], ax
mov ax, 0x4F4E
sub di, 2
mov word[es:di], ax
;end bomb





pop cx
pop di
pop es
pop ax
ret 

;coin 1
coin1:
push ax
push es
push di
push cx
cld
mov ax, 0xB800
mov es, ax
mov al, 80	
mul byte[c1y]	;get y coordinates
mov di, ax
add di, [c1x]	;get x coordinates
shl di, 1
;set starting value
sub di, 4
sub di, 160
;top left
mov ax, 0x1FC9
mov word[es:di], ax
;top
add di, 2
mov cx, 3
mov ax, 0x1FCD
rep stosw
;top right
mov ax, 0x1FBB
mov word[es:di], ax
;side walls
mov ax, 0x1FBA
add di, 160
mov word[es:di], ax
sub di, 8
mov word[es:di], ax
;bottom left
add di, 160
mov ax, 0x1FC8
mov word[es:di], ax
;below
add di, 2
mov cx, 3
mov ax, 0x1FCD
rep stosw
;bottom right
mov ax, 0x1FBC
mov word[es:di], ax
;fill
sub di, 160
sub di, 6
mov ax, 0x1F20
mov cx, 3
rep stosw
;value
mov ax, 0x1F24
sub di, 4
mov word[es:di], ax
;end coin1


;check position
cmp ax, [bxc]
jne coin1notfound
;add 5 to the score
add word [score], 5
adc word [score+2], 0
coin1notfound:




pop cx
pop di
pop es
pop ax
ret


;coin 2
coin2:
push ax
push es
push di
push cx
cld
mov ax, 0xB800
mov es, ax
mov al, 80	
mul byte[c2y]	;get y coordinates
mov di, ax
add di, [c2x]	;get x coordinates
shl di, 1
;set starting value
sub di, 4
sub di, 160
;top left
mov ax, 0x3FC9
mov word[es:di], ax
;top
add di, 2
mov cx, 3
mov ax, 0x3FCD
rep stosw
;top right
mov ax, 0x3FBB
mov word[es:di], ax
;side walls
mov ax, 0x3FBA
add di, 160
mov word[es:di], ax
sub di, 8
mov word[es:di], ax
;bottom left
add di, 160
mov ax, 0x3FC8
mov word[es:di], ax
;below
add di, 2
mov cx, 3
mov ax, 0x3FCD
rep stosw
;bottom right
mov ax, 0x3FBC
mov word[es:di], ax
;value
sub di, 160
sub di, 6
mov ax, 0x3F24
mov cx, 3
rep stosw
;fill
mov ax, 0x3F20
sub di, 4
mov word[es:di], ax
;end coin2
pop cx
pop di
pop es
pop ax
ret

;coin 3
coin3:
push ax
push es
push di
push cx
cld
mov ax, 0xB800
mov es, ax
mov al, 80	
mul byte[c3y]	;get y coordinates
mov di, ax
add di, [c3x]	;get x coordinates
shl di, 1
;set starting value
sub di, 4
sub di, 160
;top left
mov ax, 0x6FC9
mov word[es:di], ax
;top
add di, 2
mov cx, 3
mov ax, 0x6FCD
rep stosw
;top right
mov ax, 0x6FBB
mov word[es:di], ax
;side walls
mov ax, 0x6FBA
add di, 160
mov word[es:di], ax
sub di, 8
mov word[es:di], ax
;bottom left
add di, 160
mov ax, 0x6FC8
mov word[es:di], ax
;below
add di, 2
mov cx, 3
mov ax, 0x6FCD
rep stosw
;bottom right
mov ax, 0x6FBC
mov word[es:di], ax
;value
sub di, 160
sub di, 6
mov ax, 0x6F24
mov cx, 3
rep stosw
;end coin3
pop cx
pop di
pop es
pop ax
ret

bucket:
push ax
push es
push di
push cx
;start
mov ax, 0xB800
mov es, ax
;set coordinates
mov di, 1520
mov ax, word[bxc]
add di, ax
shl di, 1
;set bucket printing start position
sub di, 6
sub di, 160
;printing
;sides
mov ax, 0x70B3
mov word[es:di], ax
add di, 12
mov word[es:di], ax
add di, 160
mov word[es:di], ax
sub di, 12
mov word[es:di], ax
;bottom left
mov ax, 0x70C0
add di, 160
mov word[es:di], ax
;bottom
add di, 2
mov cx, 5
mov ax, 0x70C4
rep stosw
;bottom right
mov ax, 0x70D9
mov word[es:di], ax
;fill
mov ax, 0x7020
sub di, 160
sub di, 10
mov cx, 5
rep stosw
sub di, 160
sub di, 10
mov cx, 5
rep stosw
;logo
add di, 160
sub di, 10
mov ax, 0x704D
mov word[es:di], ax
add di, 8
mov word[es:di], ax
sub di, 4
mov ax, 0x7026
mov word[es:di], ax
;end bucket
pop cx
pop di
pop es
pop ax
ret






;background
background:
push ax
push es
push di
push cx
;start
mov ax, 0xB800
mov es, ax
mov di, 0
cld

;sky
mov ax, 0x3BDB
mov cx, 960
rep stosw
mov ax, 0x3BB2
mov cx, 240
rep stosw
mov ax, 0x3BB1
mov cx, 240
rep stosw
mov ax, 0x3BB0
mov cx, 240
rep stosw

;grass
mov ax, 0x2AB0
mov cx, 80
rep stosw

;mud
mov ax, 0x68B0
mov cx, 80
rep stosw
mov ax, 0x68B1
mov cx, 80
rep stosw
mov ax, 0x68B2
mov cx, 80
rep stosw

;tree
mov di, 2500
mov ax, 0x3AB1
mov cx, 12
cld
rep stosw	;tree middle line 1
add di, 160
sub di, 24
mov cx, 12
rep stosw	;tree middle line 2
sub di, 318
sub di, 24
mov cx, 10
rep stosw	;tree above
add di, 480
sub di, 20
mov cx, 10
rep stosw	;tree below
add di, 158
sub di, 14
mov cx, 6
rep stosw	;tree below below
sub di, 800
sub di, 12
mov cx, 6
rep stosw	;tree above above
mov ax, 0x6620
mov di, 3150
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 160
mov word[es:di], ax
sub di, 2
mov word[es:di], ax

;sun
mov di, 980
mov ax, 0x0EDB
mov cx, 12
cld
rep stosw	;sun middle line 1
add di, 160
sub di, 24
mov cx, 12
rep stosw	;sun middle line 2
sub di, 318
sub di, 24
mov cx, 10
rep stosw	;sun above
add di, 480
sub di, 20
mov cx, 10
rep stosw	;sun below
add di, 158
sub di, 14
mov cx, 6
rep stosw	;sun below below
sub di, 800
sub di, 12
mov cx, 6
rep stosw	;sun above above

;clouds
;right small cloud
mov ax, 0x7FDF	;shadows
mov cx, 20
mov di, 580
rep stosw
mov cx, 30
mov di, 414
rep stosw
mov ax, 0x7FDB	;cloud
mov cx, 20
mov di, 420
rep stosw
mov cx, 12
mov di, 280
rep stosw

;left huge cloud
mov ax, 0x7FDF	;shadows
mov cx, 10
mov di, 1134
rep stosw
mov cx, 35
mov di, 960
rep stosw
mov ax, 0x7FDB	;clouds
mov cx, 15
mov di, 800
rep stosw
mov cx, 10
mov di, 814
rep stosw
mov cx, 10
mov di, 974
rep stosw

;timer name
mov ax, 0x0F54
mov di, 0
mov word[es:di], ax
mov ax, 0x0F69
add di, 2
mov word[es:di], ax
mov ax, 0x0F6D
add di, 2
mov word[es:di], ax
mov ax, 0x0F65
add di, 2
mov word[es:di], ax
mov ax, 0x0F72
add di, 2
mov word[es:di], ax
mov ax, 0x0F3A
add di, 2
mov word[es:di], ax
mov ax, 0x0F20
add di, 2
mov word[es:di], ax

;score name
mov ax, 0x0F53
mov di, 138
mov word[es:di], ax
mov ax, 0x0F63
add di, 2
mov word[es:di], ax
mov ax, 0x0F6F
add di, 2
mov word[es:di], ax
mov ax, 0x0F72
add di, 2
mov word[es:di], ax
mov ax, 0x0F65
add di, 2
mov word[es:di], ax
mov ax, 0x0F3A
add di, 2
mov word[es:di], ax
mov ax, 0x0F20
add di, 2
mov word[es:di], ax
;end background
pop cx
pop di
pop es
pop ax
ret




















;__________________________Starting Screen_________________________________
startingscreen:
push ax
push cx
push di
push es
call background
mov ax, 0xB800
mov es, ax
mov di, 0
mov ax, 0x0BDB
mov cx, 80
rep stosw
call printbox
call printinstructions
call logo
call printgamename
pop es
pop di
pop cx
pop ax
ret


printgamename:
push ax
push si
push di
push es

cld
mov ax, 0xB800
mov es, ax
mov si, gamename
mov di, 400
sub di, 30
mov ah, 0x0F
mov cx, 7
printnextgame1name:
lodsb
stosw
loop printnextgame1name

mov ah, 0x70
mov di, 718
lodsb
stosw
lodsb
stosw

mov di, 1040
add di, 30
sub di, 14
mov ah, 0x0F
mov cx, 7
printnextgame2name:
lodsb
stosw
loop printnextgame2name

pop es
pop di
pop si
pop ax
ret


logo:
push ax
push bx
push cx
push dx
push di
push es

mov ax, 0xB800
mov es, ax

cld
mov bx, 7
mov di, 94
mov ax, 0xF0DB
printlogonext:
add di, 160
sub di, 28
mov cx, 14
rep stosw
sub bx, 1
jnz printlogonext

mov ax, 0xEEDB
mov cx, 14
mov di, 720
sub di, 14
rep stosw
sub di, 2

sub di, 14
sub di, 480

mov cx, 7
printyellow:
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
loop printyellow

mov ax, 0xCCDB
mov cx, 10
mov di, 720
sub di, 10
rep stosw
sub di, 2

sub di, 10
sub di, 320

mov cx, 5
printorange:
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
loop printorange

mov ax, 0x4420
mov cx, 6
mov di, 720
sub di, 6
rep stosw
sub di, 2

sub di, 6
sub di, 160

mov cx, 3
printred:
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
loop printred

mov ax, 0x0FDB
mov di, 720
sub di, 2
mov cx, 2
rep stosw

pop es
pop di
pop dx
pop cx
pop bx
pop ax
ret


printinstructions:
push ax
push bx
push cx
push di
push si
push es

mov ax, 0xB800
mov es, ax


mov di, 1820
mov cx, 20
mov si, instruction1
nextinstruction1:
cld
mov ah, 0x70
lodsb
stosw
loop nextinstruction1


mov di, 2124
mov cx, 36
mov si, instruction2
nextinstruction2:
cld
mov ah, 0x70
lodsb
stosw
loop nextinstruction2

mov di, 2270
mov cx, 50
mov si, instruction3
nextinstruction3:
cld
mov ah, 0x70
lodsb
stosw
loop nextinstruction3

mov di, 2938
mov cx, 22
mov si, instruction4
nextinstruction4:
cld
mov ah, 0x8E
lodsb
stosw
loop nextinstruction4

mov di, 2598
mov cx, 41
mov si, developers
nextdevelopers:
cld
mov ah, 0x70
lodsb
stosw
loop nextdevelopers

pop es
pop si
pop di
pop cx
pop bx
pop ax
ret




printbox:
push di
push ax
push cx
push es
push bx



mov bx, 11
mov ax, 0xB800
mov es, ax
cld


mov di, 1580
mov ax, 0x7720
printboxnextline:
add di, 40
mov cx, 60
rep stosw
sub bx, 1
jnz printboxnextline

mov ax, 0x78DB
mov di, 1460
mov cx, 60
rep stosw

mov cx, 11
sub di, 2
printboxright:
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
loop printboxright

mov cx, 11
mov di, 1460
printboxleft:
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
loop printboxleft


mov di, 3220
mov cx, 60
rep stosw

pop bx
pop es
pop cx
pop ax
pop di
ret







;__________________________Ending Screen_________________________________
endingscreen:
push dx
push ax
push cx
push di
push es
call background
mov ax, 0xB800
mov es, ax
mov di, 0
mov ax, 0x0BDB
mov cx, 80
rep stosw
call theend
call printendingscore
call printfinalscore
call printplayagain
pop es
pop di
pop cx
pop ax
pop dx
ret


printplayagain:
push ax
push cx
push es
push di
push si
mov ax, 0xB800
mov es, ax
mov ah, 0x8E
mov di, 2880
add di, 48

mov si, instruction6
mov cx, 28
printnextplayagain:
lodsb
stosw
loop printnextplayagain
pop si
pop di
pop es
pop cx
pop ax
ret

;Printing score at the end

printendingscore:
push ax
push bx
push es
push di

mov ax, 0xB800
mov es, ax

mov di, 2400
mov cx, 400
mov ax, 0x0F20
rep stosw

mov di, 2618
sub di, 8
mov bx, 0

mov ah, 0x0F
printendingscoreagain:
mov al, [instruction5 + bx]
inc bx
mov word[es:di], ax
add di, 2
cmp bx, 22
jne printendingscoreagain

pop di
pop es
pop bx
pop ax
ret


;printing final score
printfinalscore:
push ax
push bx
push cx
push dx
push es
push di

mov di, 2654
mov ax, 0xB800
mov es, ax

mov bx, 10
mov cx, 0
mov ax, [score]
divideagain2:
mov dx, 0
div bx
add dl, 48
push dx
inc cx
cmp ax, 0
jnz divideagain2

printfinalscoreagain:
pop ax
mov ah, 0x0F
mov word[es:di], ax
add di, 2
loop printfinalscoreagain

pop di
pop es
pop dx
pop cx
pop bx
pop ax
ret





;The End
theend:
push ax
push es
push di
push cx

mov ax, 0xB800
mov es, ax
mov di, 984

cld
mov ax, 0x0F20
;T
mov cx, 8
rep stosw
sub di, 10
add di, 160
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158

;H
sub di, 800
add di, 12

mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax

sub di, 320
add di, 2
mov cx, 3
rep stosw

sub di, 320
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax

;E
sub di, 640
add di, 4
mov cx, 7
rep stosw

add di, 160
sub di, 14
mov word[es:di], ax
add di, 2
mov word[es:di], ax

add di, 160
sub di, 2
mov cx, 5
rep stosw

add di, 160
sub di, 10
mov word[es:di], ax
add di, 2
mov word[es:di], ax

add di, 160
sub di, 2
mov cx, 7
rep stosw


;E
sub di, 640
add di, 12
mov cx, 7
rep stosw

add di, 160
sub di, 14
mov word[es:di], ax
add di, 2
mov word[es:di], ax

add di, 160
sub di, 2
mov cx, 5
rep stosw

add di, 160
sub di, 10
mov word[es:di], ax
add di, 2
mov word[es:di], ax

add di, 160
sub di, 2
mov cx, 7
rep stosw

;N
sub di, 640
add di, 2
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax

sub di, 640
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 160
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 160
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 160
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 160
mov word[es:di], ax
add di, 2
mov word[es:di], ax

sub di, 640
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax

;D
sub di, 640
add di, 4
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax

mov cx, 5
rep stosw
sub di, 640
sub di, 10
mov cx, 5
rep stosw

add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax
add di, 160
mov word[es:di], ax

add di, 158
mov word[es:di], ax
add di, 2
mov word[es:di], ax

pop cx
pop di
pop es
pop ax

ret
