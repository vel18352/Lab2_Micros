;Archivo:	Prelab2_Vel18352
;Dispositivo:   PIC16F887
;Autor:		Emilio Velasquez 18352
;Compilador:	XC8, MPLABX 5.40
;Programa:      Contador binario en Puerto A con boton de incrementar y decrementar en puerto E
;Hardware:	Leds puerto A, Botones en puerto E
;Creado:	30/01/2023
;Ultima modificacion: 30/01/2023
    
    
// PIC16F887 Configuration Bit Settings

// 'C' source line CONFIG statements

// CONFIG1
CONFIG FOSC = INTRC_NOCLKOUT// Oscillator Selection bits (INTOSCIO oscillator: I/O function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
CONFIG WDTE = OFF       // Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
CONFIG PWRTE = OFF      // Power-up Timer Enable bit (PWRT disabled)
CONFIG MCLRE = OFF      // RE3/MCLR pin function select bit (RE3/MCLR pin function is digital input, MCLR internally tied to VDD)
CONFIG CP = OFF         // Code Protection bit (Program memory code protection is disabled)
CONFIG CPD = OFF        // Data Code Protection bit (Data memory code protection is disabled)
CONFIG BOREN = OFF      // Brown Out Reset Selection bits (BOR disabled)
CONFIG IESO = OFF       // Internal External Switchover bit (Internal/External Switchover mode is disabled)
CONFIG FCMEN = OFF      // Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
CONFIG LVP = OFF       // Low Voltage Programming Enable bit (RB3/PGM pin has PGM function, low voltage programming enabled)

// CONFIG2
CONFIG BOR4V = BOR21V   // Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
CONFIG WRT = OFF        // Flash Program Memory Self Write Enable bits (Write protection off)

//#pragma CONFIG statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

#include <xc.inc>
    
PSECT udata_bank0
  Contador_1: DS 1
  Contador_2: DS 1
PSECT resVect, class=CODE,abs, delta=2
ORG 00h
;-------------------------- VECTOR RESET -------------------------------------    
resetVec:
    PAGESEL main
    goto main
PSECT code, delta=2,abs
ORG 100h
 
 
;---------Configuracion----------------
 main:
    BANKSEL ANSEL	;Seleccion de pines digitales
    CLRF    ANSEL	;Pins digitales
    CLRF    ANSELH
    
    BANKSEL TRISA	;Seleccionar banco al que pertenece el TRISA
    CLRF    TRISA
    
    BANKSEL TRISB	;Seleccionar banco al que pertenece el TRISB
    CLRF    TRISB
    
    BANKSEL TRISC	;Seleccionar banco al que pertenece el TRISC
    CLRF    TRISC
    
    BANKSEL TRISD	;Seleccionar banco al que pertenece el TRISD
    movlw   0x1F  	;Configurar primeros 5 pins inputs 
    movwf   TRISD	;Mover W a TRSID
    
    BANKSEL PORTA
    CLRF    PORTA	;Limpiar Puerto A
    CLRF    PORTB	;Limpiar Puerto B
    CLRF    PORTC	;Limpiar Puerto C
    
    movlw   0x00
    movwf   Contador_1  ;Limpiar Contador
    movlw   0x00
    movwf   Contador_2  ;Limpiar Contador
    
;-----------loop principal-------------
loop:
   BTFSS PORTD,0	;Si el botón 1 está presionado
   CALL Incrementar_1	;Incrementar el contador 1
   BTFSS PORTD,1	;Si el botón 2 está presionado
   CALL Decrementar_1	;Decrementar el contador 1
   BTFSS PORTD,2	;Si el botón 3 está presionado
   CALL Incrementar_2	;Incrementar el contador 2
   BTFSS PORTD,3	;Si el botón 4 está presionado
   CALL Decrementar_2	;Decrementar el contador 2
   BTFSS PORTD,4	;Si el botón 5 está presionado
   CALL Suma		;Hacer suma
   
   GOTO loop		;Volver al inicio del bucle



   
;-----------Sub Rutinas-------------   
Incrementar_1:
    btfss   PORTD, 0 
    goto    $-1		;Antirrebote
    incf    Contador_1  ;Incrementar 1
    movf    Contador_1, 0   ;almacena valor de contador en W
    andlw   0x0F	;Realiza un AND entre W y K, al llegar a 15 el contador lo reseteara
    movwf   PORTA	;Escribir en puerto A
    return
    
Decrementar_1:
    btfss   PORTD, 1 
    goto    $-1		;Antirrebote
    decf    Contador_1	;Decrementa 1
    movf    Contador_1, 0   ;almacena valor de contador en W
    andlw   0x0F	;Realiza un AND entre W y K, al llegar a 15 el contador lo reseteara
    movwf   PORTA	;Escribir en puerto A
    return
    
Incrementar_2:
    btfss   PORTD, 2 
    goto    $-1		;Antirrebote
    incf    Contador_2  ;Incrementar 1
    movf    Contador_2, 0   ;almacena valor de contador en W
    andlw   0x0F	;Realiza un AND entre W y K, al llegar a 15 el contador lo reseteara
    movwf   PORTB	;Escribir en puerto B
    return
    
Decrementar_2:
    btfss   PORTD, 3 
    goto    $-1		;Antirrebote
    decf    Contador_2	;Decrementa 1
    movf    Contador_2, 0   ;almacena valor de contador en W
    andlw   0x0F	;Realiza un AND entre W y K, al llegar a 15 el contador lo reseteara
    movwf   PORTB	;Escribir en puerto B
    return
    
Suma:
    btfss   PORTD, 4
    goto    $-1		;Antirrebote
    movf    PORTA, 0    ;Mover Puerto A a W
    addwf   PORTB, 0    ;Sumar Puerto A a Puerto B y almacenar en W
    movwf   PORTC       ;Mostrar en puerto C
    return
    
    
END