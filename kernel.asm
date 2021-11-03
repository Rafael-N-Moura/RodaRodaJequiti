org 0x7E00
jmp 0x0000:start

data:
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
bolo db 'a','b','c','d'
guessWord times 20 db 0
contador times 1 db 0

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
  w_sport2 db 'esgrima',0 ;7 caracteres
  w_sport3 db 'boliche',0 ;7caracteres
  dica_s db 'TEMA: Esportes',0
  
;t_tech
  w_tech1 db 'threads',0 ;7caracteres
  w_tech2 db 'teclado',0 ;7 caracteres
  w_tech3 db 'software',0 ;8caracteres
  dica_h db 'TEMA: Tecnologia',0
  
;t_countries
  w_count1 db 'belgica',0 ;7caracteres
  w_count2 db 'mexico',0 ;6 caracteres
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
tech2  db '_ _ _ _ _ _ _',0
tech3  db '_ _ _ _ _ _ _ _',0
count1 db '_ _ _ _ _ _ _',0
count2 db '_ _ _ _ _ _',0
count3 db '_ _ _ _ _ _ _',0

;game_screen
 spin_r db '> Girar Roleta [1]',0
 exit db '> Exit [ESC]',0
 guess db '> Advinhar palavra [2]',0
 score_board db'Score: ',0
 
;telagiro
str1 db '........Girando..........',0
str2 db 'Uma letra por R$:',0
lucky db 'Que sorte!                ',0
hazard db 'Que azar, voce perdeu tudo! :(',0
score_azar db 'Score R$: 0.',0


;fraseprogresso
msg_fase db 'Voce passou de fase!',0
current_score db 'Score atual R$: ',0
next_stage db '........Carregando fase........',0

;variaveis auxiliares de pontuacao
show_score times 10 db 0
soma_total dw 0
temp dw 0
salva_rand dw 0
show_valor_giro times 10 db 0
empty_s db '',0 ;usado apenas p setar o cursor


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
random_number_0to9:
  	random_start09:
  		mov AH,00h
  		int 1AH
  		
  		mov ax,dx
  		xor dx,dx
  		mov cx,10
  		div cx
  		ret
  		
;gerar letras coloridas
coloured_letter:
 mov si,str1
	mov bl,02h
	loop_print_string1:
		mov cx,1
		call delay
		lodsb
		cmp al,0
		je end_print_string1
		mov ah,0eh
		int 10h
		call random_number_0to9
		mov bl,dl
		add bl,1
		jmp loop_print_string1
	end_print_string1:
		ret

delay:
	mov ah, 86h
	;mov cx, 0
	xor dx, dx
	mov dx, 40	
	int 15h
ret



clear:                   ; mov bl, color
  ; set the cursor to top left-most corner of screen
  mov dx, 0 
  mov bh, 0      
  mov ah, 0x2
  int 0x10

  ; print 2000 blank chars to clean  
  mov cx, 2000 
  mov bh, 0
  mov al, 0x20 ; blank char
  mov ah, 0x9
  int 0x10
  
  ; reset cursor to top left-most corner of screen
  mov dx, 0 
  mov bh, 0      
  mov ah, 0x2
  int 0x10
  ret
  
 
text_progresso_fase:
mov ah, 0 ;escolhe modo videos
  	mov al, 13h ;modo VGA
  	int 10h
  
  	mov ah, 0xb ;escolhe cor da tela
  	mov bh, 0
  	mov bl, 0;cor da tela
  	int 10h
  	
  	
	mov ah,02h
	mov dh,1 ;row
	mov dl,11 ;column
	mov bl,11
	int 10h
	mov si,msg_fase
	call printf
	
	mov ah,02h
	mov dh,11 ;row
	mov dl,6 ;column
	mov bl,0xd
	int 10h
	mov si,next_stage
	call print_string
	
	mov ah,02h
	mov dh,15 ;row
	mov dl,12 ;column
	mov bl,14
	int 10h
	mov si,current_score
	call printf
	
	
	;mostrar score atual
	mov ah,02h
	mov dh,15 ;row
	mov dl,28 ;column
	mov bl,15
	int 10h
	mov si,show_score
	call printf
		
	call delay1s
	call delay1s
	call delay1s
	
	jmp prossegue_jogo
ret 
  
text_azar_body: 
	call clear
	
	
	mov ah,02h
	mov dh,8 ;row
	mov dl,9 ;column
	mov bl,10
	int 10h
	call coloured_letter
	
	mov ah,02h
	mov dh,15 ;row
	mov dl,7 ;column
	mov bl,12
	int 10h
	mov si,hazard
	call printf
	
	mov ah,02h
  	mov dh,4 ;row
  	mov dl,28 ;column
  	mov bl,14
  	int 10h
 	mov si,  score_azar
  	call printf 
  	
  	call pontuacao_zerada
  	
	call delay1s
	call delay1s
	call delay1s
	
	jmp jogo_t_body
	
ret 
text_azar_sports: 
	call clear
	
	mov ah,02h
	mov dh,8 ;row
	mov dl,9 ;column
	mov bl,10
	int 10h
	call coloured_letter
	
	mov ah,02h
	mov dh,15 ;row
	mov dl,7 ;column
	mov bl,12
	int 10h
	mov si,hazard
	call printf
	
	mov ah,02h
  	mov dh,4 ;row
  	mov dl,28 ;column
  	mov bl,14
  	int 10h
 	mov si,  score_azar
  	call printf 
  	
  	call pontuacao_zerada
	call delay1s
	call delay1s
	call delay1s
	jmp jogo_t_sports
	
ret 
text_azar_tech: 
	call clear
	
	mov ah,02h
	mov dh,8 ;row
	mov dl,9 ;column
	mov bl,10
	int 10h
	call coloured_letter
	
	mov ah,02h
	mov dh,15 ;row
	mov dl,7 ;column
	mov bl,12
	int 10h
	mov si,hazard
	call printf
	
	mov ah,02h
  	mov dh,4 ;row
  	mov dl,28 ;column
  	mov bl,14
  	int 10h
 	mov si,  score_azar
  	call printf 
  	
  	call pontuacao_zerada 
  	
	call delay1s
	call delay1s
	call delay1s
	jmp jogo_t_tech
	
ret 
text_azar_count: 
	call clear
	
	mov ah,02h
	mov dh,8 ;row
	mov dl,9 ;column
	mov bl,10
	int 10h
	call coloured_letter
	
	mov ah,02h
	mov dh,15 ;row
	mov dl,7 ;column
	mov bl,12
	int 10h
	mov si,hazard
	call printf
	
	mov ah,02h
  	mov dh,4 ;row
  	mov dl,28 ;column
  	mov bl,14
  	int 10h
 	mov si,  score_azar
  	call printf 
  	
  	call pontuacao_zerada
  
	call delay1s
	call delay1s
	call delay1s
	jmp jogo_t_count
ret 


 	
delay1s:                 ; 1 SEC DELAY
  mov cx, 0fh
  mov dx, 4240h
  mov ah, 86h
  int 15h
  ret


  ;zera tudo caso o jogador perca
  zerar_tudo:
    call pontuacao_zerada
    call zerar_words_body
    call zerar_words_sport
    call zerar_words_tech
    call zerar_words_count
    jmp start
  ret
 
  
 
  
  ;....................
prossegue_jogo:
  call terminou_jogo
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

  terminou_jogo:
  mov si, count1
  mov di, w_count1
  call strcmp_adaptada
  cmp cl, 1
  je branch20
  ret
  branch20:
  mov si,count2
  mov di, w_count2
  call strcmp_adaptada
  cmp cl, 1
  je branch21
  ret
  branch21:
  mov si,count3
  mov di, w_count3
  call strcmp_adaptada
  cmp cl, 1
  je branch22
  ret

  branch22:
  mov si, tech1
  mov di, w_tech1
  call strcmp_adaptada
  cmp cl, 1
  je branch23
  ret
  branch23:
  mov si,tech2
  mov di, w_tech2
  call strcmp_adaptada
  cmp cl, 1
  je branch24
  ret
  branch24:
  mov si,tech3
  mov di, w_tech3
  call strcmp_adaptada
  cmp cl, 1
  je branch25
  ret

  branch25:
  mov si, sport1
  mov di, w_sport1
  call strcmp_adaptada
  cmp cl, 1
  je branch26
  ret
  branch26:
  mov si,sport2
  mov di, w_sport2
  call strcmp_adaptada
  cmp cl, 1
  je branch27
  ret
  branch27:
  mov si,sport3
  mov di, w_sport3
  call strcmp_adaptada
  cmp cl, 1
  je branch28
  ret

  branch28:
  mov si, body1
  mov di, w_body1
  call strcmp_adaptada
  cmp cl, 1
  je branch29
  ret
  branch29:
  mov si,body2
  mov di, w_body2
  call strcmp_adaptada
  cmp cl, 1
  je branch30
  ret
  branch30:
  mov si,body3
  mov di, w_body3
  call strcmp_adaptada
  cmp cl, 1
  je start
  ret
  
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

strcmp_adaptada:              ; mov si, string1, mov di, string2
  .loop1:
    lodsb
    cmp al, 32
    je .loop1
    cmp al, byte[di]
    jne .notequal
    cmp al, 0
    je .equal
    inc dx
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
 
  strcmp_adaptada2:              ; mov si, string1, mov di, string2
  .bolodearroz:
    lodsb
    cmp al, 32
    je .bolodearroz
    cmp al, 0
    je .equal500
    cmp al, byte[di]
    je .increase
    
    inc di
    jmp .bolodearroz
  .increase:
    ;clc
    inc dl
    inc di
    jmp .bolodearroz
    
  .equal500:
    ;stc
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
  mov dl,9     ;column
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
  
  ;converter inteiro para string
  
  tostring:						
	push di
	.loop1:
		cmp ax, 0
		je .endloop1
		xor dx, dx
		mov bx, 10
		div bx		
		xchg ax, dx				
		add ax, 48			
		stosb
		xchg ax, dx
		jmp .loop1
	.endloop1:
	pop si
	cmp si, di
	jne .done
	mov al, 48
	stosb
	.done:
		mov al, 0
		stosb
		call reverse
		ret
		
		;printar ao inverso
reverse:
    mov di, si
    xor cx, cx

    .loop1:
        lodsb
        cmp al, 0
        je .endloop1
        inc cl
        push ax
        jmp .loop1
    
    .endloop1:

    .loop2:
        cmp cl, 0
        je .endloop2
        dec cl
        pop ax
        stosb
        jmp .loop2

        .endloop2:
        ret		
		
pontuacao: ;funcao responsavel por fazer o acrescimo da pontuacao chamar em jogo_t_...
	mov dl, byte[salva_rand]
	mov byte[temp],dl
  	mov ax,[temp]
  	imul ax,100
  	add [soma_total],ax
  	mov ax, [soma_total]
  	mov di,show_score
  	call tostring ;transformando a string show_score em string....
 ret
 
 pontuacao_zerada: ;funcao responsavel por zerar a pontuacao// chamar em todo text_azar...
 
 	mov ax,0
  	mov [soma_total],ax
  	mov di,show_score
  	call tostring ;transformando a string show_score em string....
  ret
  	
printa_valor_de_giro: ;chamar essa funcao para cada tela....

	mov ah,02h
	mov dh,15 ;row
	mov dl,30;column
	mov bl,14
	int 10h
	
	
	;isso sera uma funcao (showscore)
	mov di,show_valor_giro
	mov ax,[salva_rand]
	imul ax,100
	call tostring
	mov si,show_valor_giro
	call printf
	
	 ;call delay1s
	 ;call delay1s
	 ;call delay1s
	 
       ;so p posicionar o cursor
	mov ah,02h
	mov dh,19 ;row
	mov dl,21 ;column
	mov bl,14
	int 10h
	mov si,empty_s
	call printf
	
ret

acumula_valor_guess_words: ;inserir o valor da palavra antes de chamar a funcao
  add [soma_total],ax
  mov ax,[soma_total]
  mov di,show_score
 ret 
;------------------------TUDO DA TELA BODY------------------------------------------
jogo_t_body: ;

    call passou_de_fase_body

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
  mov dl,28 ;column
  mov bl,14
  int 10h
  
 mov si,  score_board
 call printf 
  
  mov ah,02h
  mov dh,4 ;row
  mov dl,35;column
  mov bl,14
  int 10h
  
  mov si,  show_score
  call printf

      call limite_de_letras_body
  
  
  mov ah,02h
  mov dh,20 ;row
  mov dl,30 ;column
  mov bl,14
  int 10h
  
  call getchar
  
  
    cmp al, 27
    je zerar_tudo
    ;cmp al,49
    ;jump to spinning roulette screen
    cmp al,'1'
    je decisao_de_giro1 
    ;start guessing the three words
    cmp al, '2'
    je guessing_word_body
   ;jmp jogo_t_body
   
       
  jmp jogo_t_body
  
  decisao_de_giro1:
  call random_number_0to9
  mov byte[salva_rand],dl
  mov al,dl
  cmp al,0
  je text_azar_body ;o score sera zerado...
  jmp tela_giro1
  ret 

  ;tela giro
tela_giro1:				  		
mov ah, 0 ;escolhe modo videos
  	mov al, 13h ;modo VGA
  	int 10h
  
  	mov ah, 0xb ;escolhe cor da tela
  	mov bh, 0
  	mov bl, 0;cor da tela
  	int 10h
  	
	mov ah,02h
	mov dh,8 ;row
	mov dl,9 ;column
	mov bl,10
	int 10h
	call coloured_letter
	
	mov ah,02h
	mov dh,1 ;row
	mov dl,15 ;column
	mov bl,10
	int 10h
	mov si,lucky
	call printf
	
	
	mov ah,02h
	mov dh,15 ;row
	mov dl,12 ;column
	mov bl,14
	int 10h
	mov si,str2
	call printf
	
	;mostrar valor de giro...
	call printa_valor_de_giro
	 

  call getchar
  mov cx, ax
call putchar
  call getchar
   cmp al, 0x0d
    je comparar_body
	
	jmp jogo_t_body
  
  ret

comparar_body:
  mov ax, cx
  push ax
  call comparar_word1_body
  pop ax
  push ax
  call comparar_word2_body
  pop ax
  push ax
  call comparar_word3_body
  pop ax
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
  call pontuacao
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
  call pontuacao
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
  call pontuacao
  jmp .done
  
  .done:
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
  mov ax,1500
  call acumula_valor_guess_words
  call tostring
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
  mov ax,800
  call acumula_valor_guess_words
  call tostring
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
  mov ax,1800
  call acumula_valor_guess_words
  call tostring
  call substituir_word3_body
  jmp jogo_t_body

  .neigual3:
  jmp zerar_tudo

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
  

zerar_words_body:
  mov di, body1
  mov al, '_'
  xor cx, cx

  .word1:
    cmp cx, 7
    je .transicao1
    stosb
    inc di
    inc cx
    jmp .word1

  .transicao1:
    mov di, body2
    xor cx, cx
    .word2:
    cmp cx, 6
    je .transicao2
    stosb
    inc di
    inc cx
    jmp .word2

  .transicao2:
    mov di, body3
    xor cx, cx
    .word3:
    cmp cx, 7
    je .done
    stosb
    inc di
    inc cx
    jmp .word3

    .done:     
      ret

;Verifica se o jogador já acertou as 3 palavras
passou_de_fase_body:
  xor dx, dx
  mov si, body1
  mov di, w_body1
  call strcmp_adaptada
  cmp cl, 1
  je branch2
  ret
  branch2:
  mov si,body2
  mov di, w_body2
  call strcmp_adaptada
  cmp cl, 1
  je branch3
  ret
  branch3:
  mov si,body3
  mov di, w_body3
  call strcmp_adaptada
  cmp cl, 1
  je text_progresso_fase
  ret

limite_de_letras_body:
  xor dl, dl
  mov si, body1
  mov di, w_body1
  call strcmp_adaptada2
  mov si,body2
  mov di, w_body2
  call strcmp_adaptada2
  mov si,body3
  mov di, w_body3
  call strcmp_adaptada2
  cmp dl, 10
  jnl obrigar_guess_body
  ret


obrigar_guess_body:
  call guessing_word_body
  call passou_de_fase_body
  jmp obrigar_guess_body
ret

;------------------------TUDO DA TELA SPORTS------------------------------------------
jogo_t_sports:

call passou_de_fase_sport

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
  mov dl,28 ;column
  mov bl,14
  int 10h
  
  mov si,  score_board
  call printf 
  
  mov ah,02h
  mov dh,4 ;row
  mov dl,35;column
  mov bl,14
  int 10h
  
  mov si,  show_score
  call printf

  
  call limite_de_letras_sport
	
  mov ah,02h
  mov dh,20 ;row
  mov dl,30 ;column
  mov bl,14
  int 10h
  
  call getchar
  
   
  
    cmp al, 27
    je zerar_tudo
    ;cmp al,49
    ;jump to spinning roulette screen
    cmp al,'1'
    je decisao_de_giro2 
    ;start guessing the three words
    cmp al,'2' ;start guessing the three words
    je guessing_word_sport
   ;jmp jogo_t_body
   
 


  jmp jogo_t_sports
	
 decisao_de_giro2:
  call random_number_0to9
  mov byte[salva_rand],dl
  mov al,dl
  cmp al,0
  je text_azar_sports
  jmp tela_giro2
  ret 
;...........................
 tela_giro2:				  		
mov ah, 0 ;escolhe modo videos
  	mov al, 13h ;modo VGA
  	int 10h
  
  	mov ah, 0xb ;escolhe cor da tela
  	mov bh, 0
  	mov bl, 0;cor da tela
  	int 10h
  	
	mov ah,02h
	mov dh,8 ;row
	mov dl,9 ;column
	int 10h
	call coloured_letter
	
	mov ah,02h
	mov dh,1 ;row
	mov dl,15 ;column
	mov bl,10
	int 10h
	mov si,lucky
	call printf
	
	
	mov ah,02h
	mov dh,15 ;row
	mov dl,12 ;column
	mov bl,14
	int 10h
	mov si,str2
	call printf
	
	;mostrar valor de giro...
	call printa_valor_de_giro
	
	; call delay1s
	; call delay1s
	; call delay1s
  call getchar
  mov cx, ax
call putchar
  call getchar
   cmp al, 0x0d
    je comparar_sport
	
	jmp jogo_t_sports
  
  
  ret

comparar_sport:
  mov ax, cx
  push ax
  call comparar_word1_sports
  pop ax
  push ax
  call comparar_word2_sports
  pop ax
  push ax
  call comparar_word3_sports
  pop ax
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
   call pontuacao
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
   call pontuacao
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
  call pontuacao
  jmp .done
  .done:
  ret

guessing_word_sport:
  mov di, guessWord
  call gets
  mov si, w_sport1
  mov di, guessWord
  call strcmp
  cmp cl, 0
  je .neigual1
  jmp .igual1

  .igual1:
  mov ax,1000
  call acumula_valor_guess_words
  call tostring
  call substituir_word1_sport
  jmp jogo_t_sports


  .neigual1:
  mov si, w_sport2
  mov di, guessWord
  call strcmp
  cmp cl, 0
  je .neigual2
  jmp .igual2

  .igual2:
  mov ax,1500
  call acumula_valor_guess_words
  call tostring
  call substituir_word2_sport
  jmp jogo_t_sports

  .neigual2:
  mov si, w_sport3
  mov di, guessWord
  call strcmp
  cmp cl, 0
  je .neigual3
  jmp .igual3

  .igual3:
  mov ax,2000      ;achei uma palavra dificil coloquei 2k...
  call acumula_valor_guess_words
  call tostring
  call substituir_word3_sport
  jmp jogo_t_sports

  .neigual3:
  jmp zerar_tudo

ret
substituir_word1_sport:
  mov di, sport1
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

  substituir_word2_sport:
  mov di, sport2
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


 substituir_word3_sport:
  mov di, sport3
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
  
  zerar_words_sport:
  mov di, sport1
  mov al, '_'
  xor cx, cx

  .word1:
    cmp cx, 6
    je .transicao1
    stosb
    inc di
    inc cx
    jmp .word1

  .transicao1:
    mov di, sport2
    xor cx, cx
    .word2:
    cmp cx, 7
    je .transicao2
    stosb
    inc di
    inc cx
    jmp .word2

  .transicao2:
    mov di, sport3
    xor cx, cx
    .word3:
    cmp cx, 7
    je .done
    stosb
    inc di
    inc cx
    jmp .word3

    .done:     
      ret

passou_de_fase_sport:
  mov si, sport1
  mov di, w_sport1
  call strcmp_adaptada
  cmp cl, 1
  je branch4
  ret
  branch4:
  mov si,sport2
  mov di, w_sport2
  call strcmp_adaptada
  cmp cl, 1
  je branch5
  ret
  branch5:
  mov si,sport3
  mov di, w_sport3
  call strcmp_adaptada
  cmp cl, 1
  je text_progresso_fase
  ret

limite_de_letras_sport:
  xor dl, dl
  mov si, sport1
  mov di, w_sport1
  call strcmp_adaptada2
  mov si,sport2
  mov di, w_sport2
  call strcmp_adaptada2
  mov si,sport3
  mov di, w_sport3
  call strcmp_adaptada2
  cmp dl, 12
  jnl obrigar_guess_sport
ret

obrigar_guess_sport:
  call guessing_word_sport
  call passou_de_fase_sport
  jmp obrigar_guess_sport
ret

;------------------------TUDO DA TELA TECH------------------------------------------
jogo_t_tech: ;
call passou_de_fase_tech
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
  mov dl,28 ;column
  mov bl,14
  int 10h
  
 mov si,  score_board
 call printf 
  
  mov ah,02h
  mov dh,4 ;row
  mov dl,35;column
  mov bl,14
  int 10h
  
  mov si,  show_score
  call printf


  call limite_de_letras_tech

 	mov ah,02h
  mov dh,20 ;row
  mov dl,30 ;column
  mov bl,14
  int 10h
  
  call getchar
  
  
  
    cmp al, 27
    je zerar_tudo
    ;cmp al,49
    ;jump to spinning roulette screen
    cmp al,'1'
    je decisao_de_giro3
    ;start guessing the three words
    cmp al, '2'
    je guessing_word_tech
    ;jump to spinning roulette screen
    ;cmp al,50 ;start guessing the three words
   ;jmp jogo_t_body
   


    
  jmp jogo_t_tech

  decisao_de_giro3:
  call random_number_0to9
  mov byte[salva_rand],dl
  mov al,dl
  cmp al,0
  je text_azar_tech
  jmp tela_giro3
  ret 
 ;..........................
  tela_giro3:				  		
mov ah, 0 ;escolhe modo videos
  	mov al, 13h ;modo VGA
  	int 10h
  
  	mov ah, 0xb ;escolhe cor da tela
  	mov bh, 0
  	mov bl, 0;cor da tela
  	int 10h
  	
	mov ah,02h
	mov dh,8 ;row
	mov dl,9 ;column
	int 10h
	call coloured_letter
	
	mov ah,02h
	mov dh,1 ;row
	mov dl,15 ;column
	mov bl,10
	int 10h
	mov si,lucky
	call printf
	
	
	mov ah,02h
	mov dh,15 ;row
	mov dl,12 ;column
	mov bl,14
	int 10h
	mov si,str2
	call printf
	
	
	;mostrar valor de giro...
	call printa_valor_de_giro
	
	
	; call delay1s
	; call delay1s
	; call delay1s
	
	
	
  call getchar
  mov cx, ax
call putchar
  call getchar
   cmp al, 0x0d
    je comparar_tech
	
	jmp jogo_t_tech
  
  
  ret

comparar_tech:
  mov ax, cx
  push ax
  call comparar_word1_tech
  pop ax
  push ax
  call comparar_word2_tech
  pop ax
  push ax
  call comparar_word3_tech
  pop ax
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
  call pontuacao
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
  call pontuacao
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
  call pontuacao
  jmp .done
  .done:
  ret

guessing_word_tech:
  mov di, guessWord
  call gets
  mov si, w_tech1
  mov di, guessWord
  call strcmp
  cmp cl, 0
  je .neigual1
  jmp .igual1

  .igual1:
  mov ax,1650
  call acumula_valor_guess_words 
  call tostring
  call substituir_word1_tech
  jmp jogo_t_tech


  .neigual1:
  mov si, w_tech2
  mov di, guessWord
  call strcmp
  cmp cl, 0
  je .neigual2
  jmp .igual2

  .igual2:
  mov ax,1100
  call acumula_valor_guess_words
  call tostring
  call substituir_word2_tech
  jmp jogo_t_tech

  .neigual2:
  mov si, w_tech3
  mov di, guessWord
  call strcmp
  cmp cl, 0
  je .neigual3
  jmp .igual3

  .igual3:
  mov ax ,1200
  call acumula_valor_guess_words
  call tostring
  call substituir_word3_tech
  jmp jogo_t_tech

  .neigual3:
  jmp zerar_tudo

ret
substituir_word1_tech:
  mov di, tech1
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

  substituir_word2_tech:
  mov di, tech2
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


 substituir_word3_tech:
  mov di, tech3
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
  

  zerar_words_tech:
  mov di, tech1
  mov al, '_'
  xor cx, cx

  .word1:
    cmp cx, 7
    je .transicao1
    stosb
    inc di
    inc cx
    jmp .word1

  .transicao1:
    mov di, tech2
    xor cx, cx
    .word2:
    cmp cx, 7
    je .transicao2
    stosb
    inc di
    inc cx
    jmp .word2

  .transicao2:
    mov di, tech3
    xor cx, cx
    .word3:
    cmp cx, 8
    je .done
    stosb
    inc di
    inc cx
    jmp .word3

    .done:     
      ret

passou_de_fase_tech:
  mov si, tech1
  mov di, w_tech1
  call strcmp_adaptada
  cmp cl, 1
  je branch6
  ret
  branch6:
  mov si,tech2
  mov di, w_tech2
  call strcmp_adaptada
  cmp cl, 1
  je branch7
  ret
  branch7:
  mov si,tech3
  mov di, w_tech3
  call strcmp_adaptada
  cmp cl, 1
   je text_progresso_fase
  ret

limite_de_letras_tech:
  xor dl, dl
  mov si, tech1
  mov di, w_tech1
  call strcmp_adaptada2
  mov si,tech2
  mov di, w_tech2
  call strcmp_adaptada2
  mov si,tech3
  mov di, w_tech3
  call strcmp_adaptada2
   cmp dl, 12
   jnl obrigar_guess_tech
  ret
 
 obrigar_guess_tech:
  call guessing_word_tech
  call passou_de_fase_tech
  jmp obrigar_guess_tech
ret
 
;------------------------TUDO DA TELA COUNTRIES------------------------------------------  
jogo_t_count: 
call passou_de_fase_count
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
  mov dl,28 ;column
  mov bl,14
  int 10h
  
 mov si,  score_board
 call printf 
  
  mov ah,02h
  mov dh,4 ;row
  mov dl,35;column
  mov bl,14
  int 10h
  
  mov si,  show_score
  call printf


  call limite_de_letras_count

	mov ah,02h
  mov dh,20 ;row
  mov dl,30 ;column
  mov bl,14
  int 10h
  
  call getchar
  
  
  
    cmp al, 27
    je zerar_tudo
    ;cmp al,49
    ;jump to spinning roulette screen
    cmp al,'1'
    je decisao_de_giro4
    ;start guessing the three words
    cmp al,'2' ;start guessing the three words
    je guessing_word_count
   ;jmp jogo_t_body
   
   


    
  jmp jogo_t_count

  decisao_de_giro4:
  call random_number_0to9
  mov byte[salva_rand],dl
  mov al,dl
  cmp al,0
  je text_azar_count
  jmp tela_giro4
  ret 
;................
  tela_giro4:				  		
mov ah, 0 ;escolhe modo videos
  	mov al, 13h ;modo VGA
  	int 10h
  
  	mov ah, 0xb ;escolhe cor da tela
  	mov bh, 0
  	mov bl, 0;cor da tela
  	int 10h
  	
	mov ah,02h
	mov dh,8 ;row
	mov dl,9 ;column
	int 10h
	call coloured_letter
	
	mov ah,02h
	mov dh,1 ;row
	mov dl,15 ;column
	mov bl,10
	int 10h
	mov si,lucky
	call printf
	
	
	mov ah,02h
	mov dh,15 ;row
	mov dl,12 ;column
	mov bl,14
	int 10h
	mov si,str2
	call printf
	
	;mostrar valor de giro...
	call printa_valor_de_giro
	
	
	
	; call delay1s
	; call delay1s
	; call delay1s
  call getchar
  mov cx, ax
  mov ah,02h
  mov dh,17 ;row
  mov dl,20 ;column
  mov bl,14
  int 10h
  
call putchar
  call getchar
   cmp al, 0x0d
    je comparar_count
	
	jmp jogo_t_count
  
  
  ret

comparar_count:
  mov ax, cx
  push ax
  call comparar_word1_count
  pop ax
  push ax
  call comparar_word2_count
  pop ax
  push ax
  call comparar_word3_count
  pop ax
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
  call pontuacao
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
  call pontuacao
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
  call pontuacao
  jmp .done
  .done:
  ret
 
guessing_word_count:
  mov di, guessWord
  call gets
  mov si, w_count1
  mov di, guessWord
  call strcmp
  cmp cl, 0
  je .neigual1
  jmp .igual1

  .igual1:
  mov ax,1450
  call acumula_valor_guess_words
  call tostring
  call substituir_word1_count
  jmp jogo_t_count


  .neigual1:
  mov si, w_count2
  mov di, guessWord
  call strcmp
  cmp cl, 0
  je .neigual2
  jmp .igual2

  .igual2:
  mov ax,1000
  call acumula_valor_guess_words
  call tostring
  call substituir_word2_count
  jmp jogo_t_count

  .neigual2:
  mov si, w_count3
  mov di, guessWord
  call strcmp
  cmp cl, 0
  je .neigual3
  jmp .igual3

  .igual3:
  mov ax,1590
  call acumula_valor_guess_words
  call tostring
  call substituir_word3_count
  jmp jogo_t_count

  .neigual3:
  jmp zerar_tudo

ret
substituir_word1_count:
  mov di, count1
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

  substituir_word2_count:
  mov di, count2
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


 substituir_word3_count:
  mov di, count3
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

 zerar_words_count:
  mov di, count1
  mov al, '_'
  xor cx, cx

  .word1:
    cmp cx, 7
    je .transicao1
    stosb
    inc di
    inc cx
    jmp .word1

  .transicao1:
    mov di, count2
    xor cx, cx
    .word2:
    cmp cx, 6
    je .transicao2
    stosb
    inc di
    inc cx
    jmp .word2

  .transicao2:
    mov di, count3
    xor cx, cx
    .word3:
    cmp cx, 7
    je .done
    stosb
    inc di
    inc cx
    jmp .word3

    .done:     
      ret

passou_de_fase_count:
  mov si, count1
  mov di, w_count1
  call strcmp_adaptada
  cmp cl, 1
  je branch8
  ret
  branch8:
  mov si,count2
  mov di, w_count2
  call strcmp_adaptada
  cmp cl, 1
  je branch9
  ret
  branch9:
  mov si,count3
  mov di, w_count3
  call strcmp_adaptada
  cmp cl, 1
  je text_progresso_fase
  ret

limite_de_letras_count:
  xor dl, dl
  mov si, count1
  mov di, w_count1
  call strcmp_adaptada2
  mov si,count2
  mov di, w_count2
  call strcmp_adaptada2
  mov si,count3
  mov di, w_count3
  call strcmp_adaptada2
  cmp dl, 10
  jnl obrigar_guess_count
  ret

obrigar_guess_count:
  call guessing_word_count
  call passou_de_fase_count
  jmp obrigar_guess_count
ret

 jmp $
