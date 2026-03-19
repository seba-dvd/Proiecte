.MODEL SMALL
.STACK 100H

.DATA
    ; --- MESAJE MENIU ---
    MENU_MSG    DB 10, 13, 10, 13, '=== TRANSLATOR MORSE COMPLET ==='
                DB 10, 13, '1. Text -> Morse (Scrie tot si ENTER)'
                DB 10, 13, '2. Morse -> Text (Scrie tot si ENTER)'
                DB 10, 13, '3. Afisare Dictionar (Lista completa)'
                DB 10, 13, '4. Iesire'
                DB 10, 13, 'Alege optiunea: $'
    
    ERR_OPT     DB 10, 13, 'Optiune invalida!$'
    NEWLINE     DB 10, 13, '$'
    
    ; --- MESAJE DICTIONAR ---
    SEPARATOR   DB ':   $' 
    MSG_PAUSE   DB 10, 13, '--- Apasa o tasta pentru a vedea restul ---$'

    ; --- BUFFER PRINCIPAL DE INTRARE ---
    INPUT_BUF   DB 100 DUP(0)

    ; --- VARIABILE TEXT -> MORSE ---
    MSG_TM_IN   DB 10, 13, '[Mod 1] Scrie textul: $'
    MSG_TM_OUT  DB 10, 13, 'Traducere: $'
    SPACE       DB '   $'
    SLASH       DB ' / $'
    
    ; --- DEFINITII MORSE (Compatibil TASM) ---
    M_A DB '.-$'
    M_B DB '-...$'
    M_C DB '-.-.$'
    M_D DB '-..$'
    M_E DB '.$'
    M_F DB '..-.$'
    M_G DB '--.$'
    M_H DB '....$'
    M_I DB '..$'
    M_J DB '.---$'
    M_K DB '-.-$'
    M_L DB '.-..$'
    M_M DB '--$'
    DB 13,10
    M_N DB '-.$'
    M_O DB '---$'
    M_P DB '.--.$'
    M_Q DB '--.-$'
    M_R DB '.-.$'
    M_S DB '...$'
    M_T DB '-$'
    M_U DB '..-$'
    M_V DB '...-$'
    M_W DB '.--$'
    M_X DB '-..-$'
    M_Y DB '-.--$'
    M_Z DB '--..$'
    
    ; Tabel Pointeri (MORSE_TAB)
    MORSE_TAB DW OFFSET M_A, OFFSET M_B, OFFSET M_C, OFFSET M_D, OFFSET M_E
              DW OFFSET M_F, OFFSET M_G, OFFSET M_H, OFFSET M_I, OFFSET M_J
              DW OFFSET M_K, OFFSET M_L, OFFSET M_M, OFFSET M_N, OFFSET M_O
              DW OFFSET M_P, OFFSET M_Q, OFFSET M_R, OFFSET M_S, OFFSET M_T
              DW OFFSET M_U, OFFSET M_V, OFFSET M_W, OFFSET M_X, OFFSET M_Y
              DW OFFSET M_Z

    ; --- VARIABILE MORSE -> TEXT ---
    MSG_MT_IN   DB 10, 13, '[Mod 2] Scrie Morse: $'
    MSG_MT_OUT  DB 10, 13, 'Traducere: $'
    
    ; Buffer mic decodare
    MINI_BUF    DB 10 DUP(0)  
    MINI_IDX    DW 0
    
    ; Dictionar Cautare
    DICT        DB '.-', 0, 'A', '-...', 0, 'B', '-.-.', 0, 'C', '-..', 0, 'D'
                DB '.', 0, 'E', '..-.', 0, 'F', '--.', 0, 'G', '....', 0, 'H'
                DB '..', 0, 'I', '.---', 0, 'J', '-.-', 0, 'K', '.-..', 0, 'L'
                DB '--', 0, 'M', '-.', 0, 'N', '---', 0, 'O', '.--.', 0, 'P'
                DB '--.-', 0, 'Q', '.-.', 0, 'R', '...', 0, 'S', '-', 0, 'T'
                DB '..-', 0, 'U', '...-', 0, 'V', '.--', 0, 'W', '-..-', 0, 'X'
                DB '-.--', 0, 'Y', '--..', 0, 'Z'
                DB 0 

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX 

SHOW_MENU:
    LEA DX, MENU_MSG
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    
    CMP AL, '1'
    JE APEL_MOD_1
    CMP AL, '2'
    JE APEL_MOD_2
    CMP AL, '3'
    JE APEL_MOD_3
    CMP AL, '4'
    JE IESIRE
    
    LEA DX, ERR_OPT
    MOV AH, 09H
    INT 21H
    JMP SHOW_MENU

APEL_MOD_1:
    CALL TEXT_TO_MORSE
    JMP SHOW_MENU

APEL_MOD_2:
    CALL MORSE_TO_TEXT
    JMP SHOW_MENU

APEL_MOD_3:
    CALL AFISARE_DICTIONAR
    JMP SHOW_MENU

IESIRE:
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; ==========================================================
; PROCEDURA: AFISARE DICTIONAR (CU PAGINARE)
; ==========================================================
AFISARE_DICTIONAR PROC
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H

    MOV CX, 26      ; Numarul de litere
    MOV BL, 'A'     ; Litera de start
    MOV SI, 0       ; Index tabel pointeri

LOOP_DICT:
    ; 1. Afisam Litera
    MOV DL, BL
    MOV AH, 02H
    INT 21H
    
    ; 2. Afisam ": "
    PUSH DX          ; Salvam DL
    LEA DX, SEPARATOR
    MOV AH, 09H
    INT 21H
    POP DX           ; Recuperam DL
    
    ; 3. Afisam codul Morse
    PUSH SI          ; Salvam SI
    MOV DX, MORSE_TAB[SI]
    MOV AH, 09H
    INT 21H
    POP SI           ; Recuperam SI
    
    ; 4. Rand nou
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H

    ; --- PAGINARE ---
    ; Daca am ajuns la 'M', facem pauza
    CMP BL, 'M'
    JNE CONTINUA_LOOP
    
    LEA DX, MSG_PAUSE
    MOV AH, 09H
    INT 21H
    
    ; Asteptam orice tasta (fara echo)
    MOV AH, 07H
    INT 21H
    
    ; Dupa apasare, dam un rand nou
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H

CONTINUA_LOOP:
    INC BL           ; Urmatoarea litera ASCII
    ADD SI, 2        ; Urmatorul pointer in tabel
    
    LOOP LOOP_DICT   
    
    RET
AFISARE_DICTIONAR ENDP

; ==========================================================
; PROCEDURA: CITESTE_LINIE
; ==========================================================
CITESTE_LINIE PROC
    LEA DI, INPUT_BUF 
    
CITIRE_LOOP_GEN:
    MOV AH, 01H
    INT 21H
    
    CMP AL, 13 ; Enter
    JE GATA_CITIRE
    
    MOV [DI], AL 
    INC DI       
    JMP CITIRE_LOOP_GEN

GATA_CITIRE:
    MOV BYTE PTR [DI], 0 ; Null terminator
    RET
CITESTE_LINIE ENDP

; ==========================================================
; MODUL 1: TEXT -> MORSE
; ==========================================================
TEXT_TO_MORSE PROC
    LEA DX, MSG_TM_IN
    MOV AH, 09H
    INT 21H

    CALL CITESTE_LINIE
    
    LEA DX, MSG_TM_OUT
    MOV AH, 09H
    INT 21H
    
    LEA SI, INPUT_BUF

PROCESARE_TEXT:
    MOV AL, [SI]     
    CMP AL, 0        
    JE TM_DONE       
    
    INC SI           
    
    CMP AL, ' '
    JE TM_SPACE
    
    CMP AL, 'a'
    JB TM_CHECK
    CMP AL, 'z'
    JA PROCESARE_TEXT 
    SUB AL, 32

TM_CHECK:
    CMP AL, 'A'
    JB PROCESARE_TEXT 
    CMP AL, 'Z'
    JA PROCESARE_TEXT 

    SUB AL, 'A'
    MOV BL, AL
    MOV BH, 0
    ADD BX, BX
    
    PUSH SI          
    MOV SI, BX
    MOV DX, MORSE_TAB[SI]
    MOV AH, 09H
    INT 21H
    POP SI           
    
    LEA DX, SPACE
    MOV AH, 09H
    INT 21H
    
    JMP PROCESARE_TEXT

TM_SPACE:
    LEA DX, SLASH
    MOV AH, 09H
    INT 21H
    JMP PROCESARE_TEXT

TM_DONE:
    RET
TEXT_TO_MORSE ENDP

; ==========================================================
; MODUL 2: MORSE -> TEXT
; ==========================================================
MORSE_TO_TEXT PROC
    LEA DX, MSG_MT_IN
    MOV AH, 09H
    INT 21H
    
    CALL CITESTE_LINIE
    
    LEA DX, MSG_MT_OUT
    MOV AH, 09H
    INT 21H
    
    CALL RESET_MINI_BUF
    LEA SI, INPUT_BUF 

PROCESARE_MORSE:
    MOV AL, [SI]      
    INC SI
    
    CMP AL, 0         
    JE MT_FINISH
    
    CMP AL, ' '       
    JE MT_DECODE_NOW
    
    CMP AL, '/'       
    JE MT_PRINT_SP
    
    CMP AL, '.'
    JE MT_ADD_MINI
    CMP AL, '-'
    JE MT_ADD_MINI
    JMP PROCESARE_MORSE 

MT_ADD_MINI:
    PUSH SI           
    MOV SI, MINI_IDX
    MOV MINI_BUF[SI], AL
    INC MINI_IDX
    POP SI            
    JMP PROCESARE_MORSE

MT_DECODE_NOW:
    CALL DECODE_MINI
    CALL RESET_MINI_BUF
    JMP PROCESARE_MORSE

MT_PRINT_SP:
    MOV DL, ' '
    MOV AH, 02H
    INT 21H
    JMP PROCESARE_MORSE

MT_FINISH:
    CMP MINI_IDX, 0
    JE MT_EXIT
    CALL DECODE_MINI

MT_EXIT:
    RET
MORSE_TO_TEXT ENDP

DECODE_MINI PROC
    PUSH SI             
    
    MOV SI, MINI_IDX
    MOV MINI_BUF[SI], 0 
    
    LEA DI, DICT

SEARCH_LOOP:
    MOV SI, 0           
    CMP BYTE PTR [DI], 0
    JE NOT_FOUND

COMPARE_LOOP:
    MOV AL, MINI_BUF[SI]
    MOV BL, [DI]
    
    CMP AL, BL
    JNE NEXT_ENTRY
    
    CMP AL, 0
    JE MATCH_FOUND
    
    INC SI
    INC DI
    JMP COMPARE_LOOP

NEXT_ENTRY:
    CMP BYTE PTR [DI], 0
    JE SKIP_ASCII
    INC DI
    JMP NEXT_ENTRY

SKIP_ASCII:
    ADD DI, 2
    JMP SEARCH_LOOP

MATCH_FOUND:
    INC DI
    MOV DL, [DI]
    MOV AH, 02H
    INT 21H
    POP SI
    RET

NOT_FOUND:
    MOV DL, '?'
    MOV AH, 02H
    INT 21H
    POP SI
    RET
DECODE_MINI ENDP

RESET_MINI_BUF PROC
    MOV MINI_IDX, 0
    RET
RESET_MINI_BUF ENDP

END MAIN