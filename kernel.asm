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
w4 db '> Gire a roda e digite uma letra',0
w5 db '> A cada letra acertada ha um acrescimo de pontos de acordo com o que voce tirou na roleta',0
w6 db '> O objetivo consiste em acertar todas as palavras',0
w7 db '> Voce pode advinhar a palavra toda se preferir,mas o risco e por sua conta',0 
w8 db 'INSTRUCOES',0
w9 db 'Paulo Sergio <PSGS>',0
w10 db 'Rafael Moura<RNM4>',0
w11 db 'Obrigado por jogar! <3',0
n3 db '',0
t1 db 'Escolha um tema',0 ;caso os temas na hora de jogar n sejam gerados de modo aleatorio: 
sports db '* Esportes (1)',0
health db '* Saude (2)',0
tech db ' * Tecnologia (3)',0
countries db '* Paises (4)',0
get_back db '*Pressione a tecla ESC se quiser voltar',0
arrow db '*',0
bolo db 'a','b','c','d'
guessWord times 20 db 0
;textoMenu
  tittle db 'Roda-Roda Jequiti',0
  play db 'JOGAR',0
  instruct db'Escolher tema',0
  credits db 'CREDITOS',0
;t_body
  w_body1 db 'abdomen',0 
  w_body2 db 'lingua',0
  w_body3 db 'laringe',0
  dica_b db 'TEMA: Partes do corpo humano ',0
;t_sport
  w_sport1 db 'hockey',0 ;6caracteres
  w_sport2 db 'esgrima',0 ;9 caracteres
  w_sport3 db 'boliche',0 ;7caracteres
  dica_s db 'TEMA: Esportes',0
;t_tech
  w_tech1 db 'threads',0 ;7caracteres
  w_tech2 db 'deadlock',0 ;8 caracteres
  w_tech3 db 'software',0 ;8caracteres
  dica_h db 'TEMA: Tecnologia',0
;t_countries
  w_count1 db 'belgica',0 ;7caracteres
  w_count2 db 'mocambique',0 ;10 caracteres
  w_count3 db 'noruega',0 ;7 caracteres
  dica_c db 'TEMA: Paises',0
      
;empty_strings ;usadas no jogo...
body1  db '_ _ _ _ _ _ _',0
body2  db '_ _ _ _ _ _',0
body3  db '_ _ _ _ _ _ _',0
sport1 db '_ _ _ _ _ _',0
sport2 db '_ _ _ _ _ _ _',0
sport3 db '_ _ _ _ _ _ _',0
tech1  db '_ _ _ _ _ _ _',0
tech2  db '_ _ _ _ _ _ _ _',0
tech3  db '_ _ _ _ _ _ _ _',0
count1 db '_ _ _ _ _ _ _',0
count2 db '_ _ _ _ _ _ _ _ _ _',0
count3 db '_ _ _ _ _ _ _',0
;game_screen
 spin_r db '> Girar Roleta [1]',0
 exit db '> Exit [ESC]',0
 guess db '> Advinhar palavra [2]',0
 score_board db'Score: ',0


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


;gerador de randomicos tema
random_number_tema:
  	random_start03:
  		mov AH,00h
  		int 1AH
  		mov ax,dx
  		xor dx,dx
  		mov cx,4
  		div cx
  		ret

;gerador de randomicos score
random_number_score:
  	random_start09:
  		mov AH,00h
  		int 1AH
  		mov ax,dx
  		xor dx,dx
  		mov cx,10
  		div cx
  		ret
prossegue_jogo:
  call random_number_tema
  mov al,dl
  add al,48
  cmp al,48
  je jogo_t_body
  cmp al,49
  je jogo_t_sports
  cmp al,50
  je jogo_t_tech
  cmp al,51
  je jogo_t_count
  
               ;funcao que printa as coisas gradualmente
  print_string:
	mov bl,02h
	loop_print_string:
		mov cx,1
		call delay
		lodsb
		cmp al,0
		je end_print_string
		mov ah,0eh
		int 10h
		jmp loop_print_string
	end_print_string:
		ret

delay:
	mov ah, 86h
	;mov cx, 0
	xor dx, dx
	mov dx, 40	
	int 15h
ret
  
  
  
tela_up:
  call highlight_D_off
  call highlight_M_off
  call highlight_U_on
  call getchar
  cmp al, 13
  je prossegue_jogo
  cmp al, 's'
  je tela_middle
  jmp tela_up
  ret
  
printa_num:
  mov ah,02h
  mov dh,4    ;row
  mov dl,8     ;column
  int 10h
  mov al,'0'
  call putchar
  

  mov ah,02h
  mov dh,4    ;row
  mov dl,14     ;column
  int 10h
  mov al,'1'
  call putchar
  

  mov ah,02h
  mov dh,4    ;row
  mov dl,20    ;column
  int 10h
  mov al,'2'
  call putchar
  

  mov ah,02h
  mov dh,4    ;row
  mov dl,27     ;column
  int 10h
  mov al,'3'
  call putchar
  

  mov ah,02h
  mov dh,4    ;row
  mov dl,33  ;column
  int 10h
  mov al,'4'
  call putchar
  
  
  mov ah,02h
  mov dh,18    ;row
  mov dl,8     ;column
  int 10h
  mov al,'5'
  call putchar
  

  mov ah,02h
  mov dh,18    ;row
  mov dl,14     ;column
  int 10h
  mov al,'6'
  call putchar
  

  mov ah,02h
  mov dh,18    ;row
  mov dl,20    ;column
  int 10h
  mov al,'7'
  call putchar
  

  mov ah,02h
  mov dh,18    ;row
  mov dl,27     ;column
  int 10h
  mov al,'8'
  call putchar
  

  mov ah,02h
  mov dh,18    ;row
  mov dl,33  ;column
  int 10h
  mov al,'9'
  call putchar

  ret

strcmp:              ; mov si, string1, mov di, string2
  .loop1:
    lodsb
    cmp al, byte[di]
    jne .notequal
    cmp al, 0
    je .equal
    inc di
    jmp .loop1
  .notequal:
    ;clc
    mov cl, 0
    ret
  .equal:
    ;stc
    mov cl, 1
    ret


guessing_word_body:
  mov di, guessWord
  call gets
  mov si, w_body1
  mov di, guessWord
  call strcmp
  cmp cl, 0
  je .neigual1
  jmp .igual1

  .igual1:
  call substituir_word1_body
  jmp jogo_t_body


  .neigual1:
  mov si, w_body2
  mov di, guessWord
  call strcmp
  cmp cl, 0
  je .neigual2
  jmp .igual2

  .igual2:
  call substituir_word2_body
  jmp jogo_t_body

  .neigual2:
  mov si, w_body3
  mov di, guessWord
  call strcmp
  cmp cl, 0
  je .neigual3
  jmp .igual3

  .igual3:
  call substituir_word3_body
  jmp jogo_t_body

  .neigual3:
  jmp start

    
  


  


ret
substituir_word1_body:
  mov di, body1
  mov si, guessWord

  .loop:
    lodsb
    cmp al, 0
    je .done
    stosb
    inc di
    jmp .loop

  .done:
    ret

  substituir_word2_body:
  mov di, body2
  mov si, guessWord

  .loop:
    lodsb
    cmp al, 0
    je .done
    stosb
    inc di
    jmp .loop

  .done:
    ret


 substituir_word3_body:
  mov di, body3
  mov si, guessWord

  .loop:
    lodsb
    cmp al, 0
    je .done
    stosb
    inc di
    jmp .loop

  .done:
    ret
  
gets:
    xor cx, cx
    mov dl, 27

    .loop1:
        call getchar
        cmp al, 0x08
        je .backspace
        cmp al, 0x0d
        je .done
        cmp cl, 50
        je .loop1
        stosb
        inc cl
        mov ah,02h
        mov dh,18    ;row
        inc dl     ;column
        int 10h
        call putchar
        jmp .loop1

        .backspace:
            cmp cl, 0
            je .loop1
            dec di
            dec cl
            mov byte[di], 0
            call delchar
            dec dl
            jmp .loop1
        .done:
            mov al, 0
            stosb
            call endl

ret

endl:
    mov al, 0x0a
    call putchar
    mov al, 0x0d
    call putchar
ret

delchar:
    mov al, 0x08                    
    call putchar
    mov al, ' '
    call putchar
    mov al, 0x08                   
    call putchar
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

  mov ah, 0 ;escolhe modo videos
    mov al, 12h ;modo VGA
    int 10h
  
    mov ah, 0xb ;escolhe cor da tela
    mov bh, 0
    mov bl, 0;cor da tela
    int 10h

  mov ah,02h
  mov dh,1 ;row
  mov dl,33 ;column
  mov bl,10
  int 10h

  mov si, w8
  call printf

  mov ah,02h
  mov dh,5 ;row
  mov dl,0 ;column
  mov bl,2
  int 10h

  mov si, w4
  call print_string

  mov ah,02h
  mov dh,9 ;row
  mov dl,0 ;column
  mov bl,2
  int 10h

  mov si, w5
  call print_string
  mov ah,02h
  mov dh,13 ;row
  mov dl,0 ;column
  mov bl,2
  int 10h

  mov si, w6
  call print_string

  mov ah,02h
  mov dh,17 ;row
  mov dl,0 ;column
  mov bl,2
  int 10h
  
  mov si, w7
  call print_string

  mov ah,02h
  mov dh,21 ;row
  mov dl,0 ;column
  mov bl,3
  int 10h

  mov si, get_back
  call printf

  call getchar
    cmp al, 27
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
  call print_string

  mov ah,02h
  mov dh,9 ;row
  mov dl,5 ;column
  mov bl,3
  int 10h

  mov si, w10
  call print_string

  mov ah,02h
  mov dh,14 ;row
  mov dl,5 ;column
  mov bl,3
  int 10h

  mov si, n3
  call printf
  ;;;
  mov ah,02h
  mov dh,20 ;row
  mov dl,5 ;column
  mov bl,0xc
  int 10h

  mov si, w11
  call print_string

  call getchar
    cmp al, 27
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
  mov ah, 0 ;escolhe modo videos
  mov al, 13h ;modo VGA
  int 10h
  
  mov ah, 0xb ;escolhe cor da tela
  mov bh, 0
  mov bl, 0;cor da tela
  int 10h

  mov ah, 0xe ;escolhe cor da letra
  mov bh, 0   ;numero da pagina
  mov bl, 0xf ;cor branca da letra
 
 
finish:
  ret
;------------------------TUDO DA TELA BODY------------------------------------------
jogo_t_body: ;
mov ah, 0 ;escolhe modo videos
  	mov al, 13h ;modo VGA
  	int 10h
  
  	mov ah, 0xb ;escolhe cor da tela
  	mov bh, 0
  	mov bl, 1;cor da tela
  	int 10h
	mov ah,02h
	mov dh,1 ;row
	mov dl,6 ;column
	mov bl,10
	int 10h
	mov si, dica_b
	call printf
  mov ah,02h
  
	mov dh,7 ;row
	mov dl,11 ;column
	mov bl,15
	int 10h
	mov si, body1
	call printf
	
  mov ah,02h
  mov dh,10 ;row
  mov dl,12 ;column
  mov bl,15
  int 10h
  
  mov si, body2
  call printf
  
  mov ah,02h
  mov dh,13 ;row
  mov dl,11 ;column
  mov bl,15
  int 10h
  
  mov si, body3
  call printf
  
  mov ah,02h
  mov dh,18 ;row
  mov dl,0 ;column
  mov bl,11
  int 10h
  
  mov si,spin_r
  call printf
  
  mov ah,02h
  mov dh,20 ;row
  mov dl,0 ;column
  mov bl,11
  int 10h
  
  mov si,  guess
  call printf
  
  mov ah,02h
  mov dh,22 ;row
  mov dl,0 ;column
  mov bl,11
  int 10h
  
  mov si,exit
  call printf
  
  mov ah,02h
  mov dh,4 ;row
  mov dl,31 ;column
  mov bl,14
  int 10h
  
 mov si,  score_board
  call printf 
  
  
  mov ah,02h
  mov dh,20 ;row
  mov dl,30 ;column
  mov bl,14
  int 10h
  
  call getchar
  
    cmp al, 27
    je start
    ;cmp al,49
    ;jump to spinning roulette screen
    ;cmp al,50 ;
    ;start guessing the three words
    cmp al, '1'
    je guessing_word_body
   ;jmp jogo_t_body
mov cx, ax
call putchar
  call getchar
   cmp al, 0x0d
    je comparar_body
   
    
  jmp jogo_t_body


comparar_body:
  mov ax, cx
  call comparar_word1_body
  call comparar_word2_body
  call comparar_word3_body
  jmp jogo_t_body
ret

comparar_word1_body:
  mov di, body1
  mov si, w_body1
  xor cx, cx
  xor dx, dx
  .loop:
  cmp dx, 8
  je .done
  cmp al, [si]
  je .substituir_letra
  inc si
  inc dx
  inc cx
  jmp .loop

  .substituir_letra:
  add cx, cx
  add di, cx
  stosb
  jmp .done
  
  .done:
  ret

comparar_word2_body:
 xor di, di
  xor si, si
  mov di, body2
  mov si, w_body2
  xor cx, cx
  xor dx, dx
  .loop:
  cmp dx, 6
  je .done
  cmp al, [si]
  je .substituir_letra
  inc si
  inc dx
  inc cx
  jmp .loop

  .substituir_letra:
  add cx, cx
  add di, cx
  stosb
  jmp .done

  .done:
    ret	

comparar_word3_body:
  mov di, body3
  mov si, w_body3
  xor cx, cx
  xor dx, dx
  .loop:
  cmp dx, 8
  je .done
  cmp al, [si]
  je .substituir_letra
  inc si
  inc dx
  inc cx
  jmp .loop

  .substituir_letra:
  add cx, cx
  add di, cx
  stosb
  jmp .done
  
  .done:
  ret



;------------------------TUDO DA TELA SPORTS------------------------------------------
jogo_t_sports:

mov ah, 0 ;escolhe modo videos
  	mov al, 13h ;modo VGA
  	int 10h
  
  	mov ah, 0xb ;escolhe cor da tela
  	mov bh, 0
  	mov bl, 1;cor da tela
  	int 10h

	mov ah,02h
	mov dh,1 ;row
	mov dl,12 ;column
	mov bl,5
	int 10h

	mov si, dica_s
	call printf

  mov ah,02h
	mov dh,7 ;row
	mov dl,13 ;column
	mov bl,15
	int 10h

	mov si, sport1
	call printf

  mov ah,02h
  mov dh,10 ;row
  mov dl,10 ;column
  mov bl,15
  int 10h

  mov si, sport2
  call printf

  mov ah,02h
  mov dh,13 ;row
  mov dl,12 ;column
  mov bl,15
  int 10h

  mov si, sport3
  call printf

  mov ah,02h
  mov dh,18 ;row
  mov dl,0 ;column
  mov bl,11
  int 10h
  
  mov si,spin_r
  call printf

  mov ah,02h
  mov dh,20 ;row
  mov dl,0 ;column
  mov bl,11
  int 10h

  mov si,  guess
  call printf
  
  mov ah,02h
  mov dh,22 ;row
  mov dl,0 ;column
  mov bl,11
  int 10h
  
  mov si,exit
  call printf
  
  mov ah,02h
  mov dh,4 ;row
  mov dl,31 ;column
  mov bl,14
  int 10h
  
  
  
  mov si,  score_board
  call printf

	 mov ah,02h
  mov dh,20 ;row
  mov dl,30 ;column
  mov bl,14
  int 10h
  
  call getchar
  
    cmp al, 27
    je start
    ;cmp al,49
    ;jump to spinning roulette screen
    ;cmp al,50 ;start guessing the three words
   ;jmp jogo_t_body
mov cx, ax
call putchar
  call getchar
   cmp al, 0x0d
    je comparar_sport

  jmp jogo_t_sports
	

comparar_sport:
  mov ax, cx
  call comparar_word1_sports
  call comparar_word2_sports
  call comparar_word3_sports
  jmp jogo_t_sports
ret

comparar_word1_sports:
  mov di, sport1
  mov si, w_sport1
  xor cx, cx
  xor dx, dx
  .loop:
  cmp dx, 6 ;9, 7
  je .done
  cmp al, [si]
  je .substituir_letra
  inc si
  inc dx
  inc cx
  jmp .loop

  .substituir_letra:
  add cx, cx
  add di, cx
  stosb
  jmp .done
  
  .done:
  ret

comparar_word2_sports:
  mov di, sport2
  mov si, w_sport2
  xor cx, cx
  xor dx, dx
  .loop:
  cmp dx, 7 
  je .done
  cmp al, [si]
  je .substituir_letra
  inc si
  inc dx
  inc cx
  jmp .loop

  .substituir_letra:
  add cx, cx
  add di, cx
  stosb
  jmp .done
  
  .done:
  ret

comparar_word3_sports:
  mov di, sport3
  mov si, w_sport3
  xor cx, cx
  xor dx, dx
  .loop:
  cmp dx, 7 ;9
  je .done
  cmp al, [si]
  je .substituir_letra
  inc si
  inc dx
  inc cx
  jmp .loop

  .substituir_letra:
  add cx, cx
  add di, cx
  stosb
  jmp .done
  
  .done:
  ret




;------------------------TUDO DA TELA TECH------------------------------------------
jogo_t_tech: ;
mov ah, 0 ;escolhe modo videos
    mov al, 13h ;modo VGA
    int 10h
  
    mov ah, 0xb ;escolhe cor da tela
    mov bh, 0
    mov bl, 1;cor da tela
    int 10h

  mov ah,02h
  mov dh,1 ;row
  mov dl,11 ;column
  mov bl,9
  int 10h

  mov si, dica_h
  call printf

  mov ah,02h
  mov dh,7 ;row
  mov dl,12 ;column
  mov bl,15
  int 10h

  mov si, tech1
  call printf

  mov ah,02h
  mov dh,10 ;row
  mov dl,11 ;column
  mov bl,15
  int 10h

  mov si, tech2
  call printf

  mov ah,02h
  mov dh,13 ;row
  mov dl,11 ;column
  mov bl,15
  int 10h

  mov si, tech3
  call printf

  mov ah,02h
  mov dh,18 ;row
  mov dl,0 ;column
  mov bl,11
  int 10h
  
  mov si,spin_r
  call printf

  mov ah,02h
  mov dh,20 ;row
  mov dl,0 ;column
  mov bl,11
  int 10h

  mov si,  guess
  call printf
  
  mov ah,02h
  mov dh,22 ;row
  mov dl,0 ;column
  mov bl,11
  int 10h
  
  mov si,exit
  call printf
  
  mov ah,02h
  mov dh,4 ;row
  mov dl,31 ;column
  mov bl,14
  int 10h
  
  
  
  mov si,  score_board
  call printf

 	 mov ah,02h
  mov dh,20 ;row
  mov dl,30 ;column
  mov bl,14
  int 10h
  
  call getchar
  
    cmp al, 27
    je start
    ;cmp al,49
    ;jump to spinning roulette screen
    ;cmp al,50 ;start guessing the three words
   ;jmp jogo_t_body
mov cx, ax
call putchar
  call getchar
   cmp al, 0x0d
    je comparar_tech
    
  jmp jogo_t_tech

comparar_tech:
  mov ax, cx
  call comparar_word1_tech
  call comparar_word2_tech
  call comparar_word3_tech
  jmp jogo_t_tech
ret

comparar_word1_tech:
  mov di, tech1
  mov si, w_tech1
  xor cx, cx
  xor dx, dx
  .loop:
  cmp dx, 7 ;9, 7
  je .done
  cmp al, [si]
  je .substituir_letra
  inc si
  inc dx
  inc cx
  jmp .loop

  .substituir_letra:
  add cx, cx
  add di, cx
  stosb
  jmp .done
  
  .done:
  ret

comparar_word2_tech:
 xor di, di
  xor si, si
  mov di, tech2
  mov si, w_tech2
  xor cx, cx
  xor dx, dx
  .loop:
  cmp dx, 8
  je .done
  cmp al, [si]
  je .substituir_letra
  inc si
  inc dx
  inc cx
  jmp .loop

  .substituir_letra:
  add cx, cx
  add di, cx
  stosb
  jmp .done

  .done:
    ret	

comparar_word3_tech:
  mov di, tech3
  mov si, w_tech3
  xor cx, cx
  xor dx, dx
  .loop:
  cmp dx, 8 ;9
  je .done
  cmp al, [si]
  je .substituir_letra
  inc si
  inc dx
  inc cx
  jmp .loop

  .substituir_letra:
  add cx, cx
  add di, cx
  stosb
  jmp .done
  
  .done:
  ret




 
;------------------------TUDO DA TELA COUNTRIES------------------------------------------  
jogo_t_count: 
mov ah, 0 ;escolhe modo videos
    mov al, 13h ;modo VGA
    int 10h
  
    mov ah, 0xb ;escolhe cor da tela
    mov bh, 0
    mov bl, 1;cor da tela
    int 10h

  mov ah,02h
  mov dh,1 ;row
  mov dl,11 ;column
  mov bl,2
  int 10h

  mov si, dica_c
  call printf

  mov ah,02h
  mov dh,7 ;row
  mov dl,12 ;column
  mov bl,15
  int 10h

  mov si, count1
  call printf

  mov ah,02h
  mov dh,10 ;row
  mov dl,9 ;column
  mov bl,15
  int 10h

  mov si, count2
  call printf

  mov ah,02h
  mov dh,13 ;row
  mov dl,12 ;column
  mov bl,15
  int 10h

  mov si, count3
  call printf

  mov ah,02h
  mov dh,18 ;row
  mov dl,0 ;column
  mov bl,11
  int 10h
  
  mov si,spin_r
  call printf

  mov ah,02h
  mov dh,20 ;row
  mov dl,0 ;column
  mov bl,11
  int 10h

  mov si,  guess
  call printf
  
  mov ah,02h
  mov dh,22 ;row
  mov dl,0 ;column
  mov bl,11
  int 10h
  
  mov si,exit
  call printf
  
  mov ah,02h
  mov dh,4 ;row
  mov dl,31 ;column
  mov bl,14
  int 10h
  
  
  
  mov si,  score_board
  call printf

	 mov ah,02h
  mov dh,20 ;row
  mov dl,30 ;column
  mov bl,14
  int 10h
  
  call getchar
  
    cmp al, 27
    je start
    ;cmp al,49
    ;jump to spinning roulette screen
    ;cmp al,50 ;start guessing the three words
   ;jmp jogo_t_body
mov cx, ax
call putchar
  call getchar
   cmp al, 0x0d
    je comparar_count
    
  jmp jogo_t_count

comparar_count:
  mov ax, cx
  call comparar_word1_count
  call comparar_word2_count
  call comparar_word3_count
  jmp jogo_t_count
ret

comparar_word1_count:
  mov di, count1
  mov si, w_count1
  xor cx, cx
  xor dx, dx
  .loop:
  cmp dx, 7 ;9, 7
  je .done
  cmp al, [si]
  je .substituir_letra
  inc si
  inc dx
  inc cx
  jmp .loop

  .substituir_letra:
  add cx, cx
  add di, cx
  stosb
  jmp .done
  
  .done:
  ret

comparar_word2_count:
 xor di, di
  xor si, si
  mov di, count2
  mov si, w_count2
  xor cx, cx
  xor dx, dx
  .loop:
  cmp dx, 10
  je .done
  cmp al, [si]
  je .substituir_letra
  inc si
  inc dx
  inc cx
  jmp .loop

  .substituir_letra:
  add cx, cx
  add di, cx
  stosb
  jmp .done

  .done:
    ret	

comparar_word3_count:
  mov di, count3
  mov si, w_count3
  xor cx, cx
  xor dx, dx
  .loop:
  cmp dx, 7 ;9
  je .done
  cmp al, [si]
  je .substituir_letra
  inc si
  inc dx
  inc cx
  jmp .loop

  .substituir_letra:
  add cx, cx
  add di, cx
  stosb
  jmp .done
  
  .done:
  ret
 



 jmp $
