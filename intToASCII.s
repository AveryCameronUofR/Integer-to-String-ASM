;ARM1.s Source code for q1 of assignment 3
;Function Modify some registers so we can observe the results in the debugger
;Author - Avery Cameron
; Directives
	PRESERVE8
	THUMB
		
; Vector Table Mapped to Address 0 at Reset, Linker requires __Vectors to be exported
	AREA RESET, DATA, READONLY
	EXPORT 	__Vectors


__Vectors DCD 0x20002000 ; stack pointer value when stack is empty
	DCD Reset_Handler ; reset vector
	
	ALIGN


;My program, Linker requires Reset_Handler and it must be exported
	AREA MYCODE, CODE, READONLY
	ENTRY

	EXPORT Reset_Handler
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Program: Converts an integer value to an ASCII string stored in a buffer, location held in R10
;;	initial loads store starting values for int_to_ascii function 
;;	Avery Cameron, October 17, 2018
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Reset_Handler
	LDR R9, =-34		 ;Used to hold the number to turn into an ascii string
	LDR R10, =0x20000030 ;holds the buffer location in memory	 
	
	BL int_to_ascii		 ;branches to int_to_ascii function
	
deadEnd
	B deadEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function: int_to_ascii
;; Requires:
;;		Buffer to string in memory in R10
;;		Number to convert to ascii string in R9
;;		A -1 in R3, to convert from negative to positive quickly
;;		0 in R1
;;		R10 in first position of stack
;;		R1 in second position of stack
;; Returns:
;;		R10 is at start of buffer, values will be changed accordingly
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
int_to_ascii	PROC
	push {R10}			 ;pushes Register 10, memory location, to stack
	push{LR}			 ;pushes Link Register to stack
	MOV R1, #0x00
	push {R1}			 ;Puhses R1, 00, to stack to append a 00 to the end of the ascii string later
	CMP R9, #0			 ;checks if R9 holds a negative value, (Branch minus), else branch positive
	BMI isNegative	
	B	isPositive
;if it is negative
isNegative			;if it is negative, at start of ascii string put a 2D(-) at the start
	MOV R0, #0x2D
	STRB R0, [R10]	;stores R0 in buffer at R10 and increments buffer position
	ADD R10, #1	
	LDR R3 , =-1	;used to hold -1, for conversion from negative to postive
	MUL R9, R9, R3	;multiplies by -1 to change value to positive
	B convertToString
;if positive
isPositive
	MOV R0, #0x20	;if positive, add 20 ( ) to start of string
	STRB R0, [R10]	;stores R0 in memory position held in R10
	ADD R10, #1		;increments buffer position
	B convertToString	
	
;converts integer to ascii values	
;loop to get each value individually and push ascii value to stack
convertToString		
	MOV R1, #10		  ;puts 10 in R1 to allow division by 10
	SDIV R2, R9, R1	  ;does signed division, divides R9 by 10 (stored in R1) and stores in R2

	MUL R0, R1, R2	  ;multiplies R2 (result of division by 10) by 10 (stored in R1) and stores in R0
	SUB R0, R9, R0	  ;subtracts R0 from R9, (whole number without leading integer, ex 34 -> 3 -> 30) (34 -30 = 4 (integer at start)
	ADD R0, #0x30	  ;creates ascii equivalent (add 30 hex)
	push{R0}		  ;pushes value to stack
	MOV R9, R2	      ;moves value in R2 (division of R9 by 10) to R9 (the original string is divided by 10 and checked to see if end is reached)
	CMP R2, #0x0
	BEQ popToBuffer	  ;branches if traversal complete (R2 = 0)
	B convertToString ;branches to convertToString again and loops, there are still values to determine

;pops results of convertToString nd stores in buffer
popToBuffer			
	pop{R0}			;pops most recent value first (right most integer goes to right most buffer)
	STRB R0, [R10]
	CMP R0, #00		;once you have popped the 0x00 originally pushed to stack
	BEQ complete	;stack only contains LR and buffer start position, branch to complete
	ADD R10, #1		;increment position in memory
	B popToBuffer
	
;number has been traversed, converted and stored in buffer
complete
	pop {LR}			;pop LR (found in stack) pushed at start of int_to_ascii (allows return  to outside of function)
	pop{R10}			;pops item in stack, memory buffer location, to R10 (puts original value back in)
	BX LR	;branches to LR
	ENDP	

;end of assembly file
	ALIGN
	END