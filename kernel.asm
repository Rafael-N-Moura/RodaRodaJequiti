
org 0x7E00
jmp 0x0000:start
data:
;no reg ax estara o score...
	xor ax, ax   ;zerando todos os regs que serao utilizados
  	mov cx, ax  
  	mov ds, ax
  	mov es, ax
;aux_texts
w1 db 'Digite a palavra1: ',0
w2 db 'Digite a palavra2: ',0
w3 db 'Digite a palavra3: ',0
w4 db 'Escolha uma letra e gire a roda',0
w5 db 'A cada letra acertada ha um acrescimo de pontos',0
w6 db 'O objetivo e acertar todas as palavras',0
w8 db 'Instrucoes',0
w9 db 'Paulo Sergio',0
w10 db 'Rafael Moura',0
n3 db '',0
get_back db '*Pressione a tecla ESC se quiser voltar',0
arrow db '*',0
;textoMenu
	tittle db 'Roda-Roda Jequiti',0
	play db 'JOGAR',0
	instruct db'Escolher tema',0
	credits db 'Creditos',0
;t_body
	w_body1 db 'estomago',0 
	w_body2 db 'maxilar',0
	w_body3 db 'pescoco',0
	dica_b db 'TEMA: Partes do corpo humano ',0
;t_sport
	w_sport1 db 'hockey',0 ;6caracteres
	w_sport2 db 'tenis de mesa',0 ;13 caracteres
	w_sport3 db 'futebol de praia',0
	dica_s db 'TEMA: Esportes',0
;t_tech
	w_tech1 db 'threads',0
	w_tech2 db 'deadlock',0
	w_tech3 db 'concorrencia',0
	dica_h db 'TEMA: Tecnologia',0
;t_countries
	w_count1 db 'belgica',0
	w_count2 db 'colombia',0
	w_count3 db 'alemanha',0
    	dica_c db 'TEMA: Paises',0
start:
  xor ax, ax
  mov cx, ax
  mov ds, ax
  mov es, ax

	call modo_video

  call printa_tittle
  call printa_play
  call printa_w8
  call printa_credits
  call tela_up

  jmp $

tela_up:
  call highlight_D_off
  call highlight_M_off
  call highlight_U_on
  call getchar
  cmp al, 13
  je jogo
  cmp al, 's'
  je tela_middle
  jmp tela_up
  ret

tela_down:
  call highlight_U_off
  call highlight_M_off
  call highlight_D_on
  call getchar
  cmp al, 13
  je tela_credits
  cmp al, 'w'
  je tela_middle
  jmp tela_down
  ret

tela_middle:
  call highlight_U_off
  call highlight_D_off
  call highlight_M_on
  call getchar
  cmp al, 13
  je tela_w8
  cmp al, 'w'
  je tela_up
  cmp al, 's'
  je tela_down
  jmp tela_middle
  ret

printa_tittle:
  mov ah,02h
  mov dh,3    ;row
  mov dl,10     ;column
  int 10h

  mov si, tittle
  call printf
  ret

printa_play:
  mov ah,02h
  mov dh,10    ;row
  mov dl,15     ;column
  mov bl, 5
  int 10h

  mov si, play
  call printf
  ret

printa_w8:
  mov ah,02h
  mov dh,12    ;row
  mov dl,15     ;column
  mov bl, 2
  int 10h

  mov si, w8
  call printf
  ret

printa_credits:
  mov ah,02h
  mov dh,14    ;row
  mov dl,15     ;column
  mov bl, 0xf
  int 10h

  mov si, credits
  call printf
  ret

highlight_U_on:
  mov ah,02h
  mov dh,10    ;row
  mov dl,15     ;column
  mov bl, 0xe
  int 10h

  mov si, play
  call printf
  ret

  highlight_M_on:
    mov ah,02h
    mov dh,12    ;row
    mov dl,15     ;column
    mov bl, 0xe
    int 10h

    mov si, w8
    call printf
    ret

highlight_D_on:
  mov ah,02h
  mov dh,14    ;row
  mov dl,15     ;column
  mov bl, 0xe
  int 10h

  mov si, credits
  call printf
  ret

tela_w8:

	call modo_video

	mov ah,02h
	mov dh,1 ;row
	mov dl,17 ;column
	mov bl,10
	int 10h

	mov si, w8
	call printf

  mov ah,02h
	mov dh,4 ;row
	mov dl,0 ;column
	mov bl,2
	int 10h

	mov si, w4
	call printf

  mov ah,02h
  mov dh,9 ;row
  mov dl,0 ;column
  mov bl,2
  int 10h

  mov si, w5
  call printf

  mov ah,02h
  mov dh,13 ;row
  mov dl,0 ;column
  mov bl,2
  int 10h

  mov si, w6
  call printf

  mov ah,02h
  mov dh,20 ;row
  mov dl,0 ;column
  mov bl,3
  int 10h

  mov si, get_back
  call printf

	call getchar
    cmp al, 'b'
    je start
	jmp tela_w8

tela_credits:
  call modo_video

  mov ah,02h
  mov dh,1 ;row
  mov dl,15 ;column
  mov bl,1
  int 10h

  mov si, credits
  call printf

  mov ah,02h
  mov dh,4 ;row
  mov dl,5 ;column
  mov bl,3
  int 10h

  mov si, w9
  call printf

  mov ah,02h
  mov dh,9 ;row
  mov dl,5 ;column
  mov bl,3
  int 10h

  mov si, w10
  call printf

  mov ah,02h
  mov dh,14 ;row
  mov dl,5 ;column
  mov bl,3
  int 10h

  mov si, n3
  call printf

  call getchar
    cmp al, '27'
    je start
  jmp tela_credits

highlight_D_off:
  mov ah,02h
  mov dh,14    ;row
  mov dl,15     ;column
  mov bl, 8
  int 10h

  mov si, credits
  call printf
  ret

highlight_M_off:
  mov ah,02h
  mov dh,12    ;row
  mov dl,15     ;column
  mov bl,2
  int 10h

  mov si, w8
  call printf
  ret

highlight_U_off:
  mov ah,02h
  mov dh,10    ;row
  mov dl,15     ;column
  mov bl, 4
  int 10h

  mov si, play
  call printf
  ret

printf:
  lodsb
  cmp al, 0
  je finish
  mov ah, 0eh
  int 10h
  jmp printf
  ret

getchar:
  mov ah, 00h
  int 16h
  ret

putchar:
  mov ah, 0eh ;modo de imprmir na tela
  int 10h ;imprime o que tá em al
  ret
  
modo_video:
  mov ah, 0 ;escolhe modo video
  mov al, 13h ;modo VGA
  int 10h
  
  mov ah, 0xb ;escolhe cor da tela
  mov bh, 0
  mov bl, 1 ;cor da tela
  int 10h

  mov ah, 0xe ;escolhe cor da letra
  mov bh, 0   ;numero da pagina
  mov bl, 0xf ;cor branca da letra
  
finish:
  ret

jogo:
 jmp $
