name = "Calcoolator"

include emu8086.inc

org 100h
.data
  titleMsg  db 0ah,0dh,  "  WELCOME TO SIGMA CALCULATOR",0                                 ;0 is the null terminating character 

  menu1 db 0ah,0dh,  "   (+) Addition"
        db 0ah,0dh,  "   (-) Subtraction"
        db 0ah,0dh,  "   (*) Multiplication"
        db 0ah,0dh,  "   (/) Divsion"
        db 0ah,0dh,  "   (%) Modulus"
        db 0ah,0dh,  "   (e) Exponents"
        db 0ah,0dh,  "   (f) Factorial" 
        db 0ah,0dh,  "   (c) Conversions",0
        
  menu2 db 0ah,0dh,  "   (1) Celsius to Fahrenheit"
        db 0ah,0dh,  "   (2) Fahrenheit to Celsius"
        db 0ah,0dh,  "   (0) Back to menu", 0
                 
        

 line db "-------------------------------$"      
 newLine db 0ah,0dh, "$" 
                   
 choice db ? 
 
 ;num dw ?
         
         
.code 
main proc                                            
 
   
  call menu    
  
  ret
 
main endp

;menu procedure/function
Menu proc 
    
  call clear_screen
  call print_line                                     
                 
  mov    SI, offset titleMsg     
  CALL   print_string
  
     
  call new_line
  call print_line

  mov si, offset menu1
  call print_string  
  
  redo:
   call new_line
   call print_line  
  
   printn            
   print "Choose an operation: " 
  
   call single_input
 
   cmp choice, '+'             ; if choice = +, go to AddNum 
   je AddNum                   
                               ; THIS JUMP HAS THE ADDITION LOGIC BELOW
   cmp choice, '-'
   je SubNum
   
   cmp choice, '*'
   je MulNum
   
   cmp choice, '/'
   je DivNum
   
   cmp choice, '%'
   je ModNum                   
 
   cmp choice, 'e'             
   je ExponentNum   
                               
   cmp choice, 'f'
   je FacNum            ; if choice = f, go to fac
   
   
   cmp choice, 'c'
   je convert
  convert:
    call conversions
    
  jne invalid


invalid:
 printn
 print "INVALID OPERATOR!, TRY AGAIN"
 
 jmp redo
 
       

   
Menu endp





; operations(+,-,/,*, %) are defined as jump labels:


AddNum:                         ; Addition:      (just copy paste and change the instuctions to sub for subtraction etc, 
                                ;mul and div only use one reg [div ax], check docs too)
  call clear_screen 

  printn "----------"
  printn " Addition "   
  printn "----------"  

           
  print "Enter First Number : "
  call scan_num
  mov ax, cx  
           
  printn            
  print "Enter Second Number: "
  call scan_num
  mov bx, cx                
  
  add ax, bx
  printn 
  print "Result             : "
  call print_num 

  call new_line
  call print_line
               
  call back_to_menu



; subtraction jump
SubNum:  

  call clear_screen 

  printn "-------------"
  printn " Subtraction "   
  printn "-------------"  

           
  print "Enter First Number : "
  call scan_num
  mov ax, cx  
           
  printn            
  print "Enter Second Number: "
  call scan_num
  mov bx, cx                
  
  sub ax, bx
  printn 
  print "Result             : "
  call print_num 

  call new_line
  call print_line
               
  call back_to_menu  


MulNum: 

  call clear_screen 

  printn "----------------"
  printn " Multiplication "   
  printn "----------------"  

           
  print "Enter First Number : "
  call scan_num
  mov ax, cx  
           
  printn            
  print "Enter Second Number: "
  call scan_num
  mov bx, cx                
  
  mul bx
  printn 
  print "Result             : "
  call print_num 

  call new_line
  call print_line
               
  call back_to_menu 
    
 
DivNum: 

  call clear_screen 

  printn "----------"
  printn " Division "   
  printn "----------"  

           
  print "Enter First Number : "
  call scan_num
  mov ax, cx  
           
  printn            
  print "Enter Second Number: "
  call scan_num
  mov bx, cx                
  
  div bx
  printn 
  print "Result             : "
  call print_num 

  call new_line
  call print_line
               
  call back_to_menu 
  

ModNum: 

  call clear_screen 

  printn "---------"
  printn " Modulus "   
  printn "---------"  

           
  print "Enter First : "
  call scan_num
  mov ax, cx  
           
  printn            
  print "Enter the divisor: "
  call scan_num
  mov bx, cx                
  
  div bx
  mov ax, dx
  printn 
  print "Result             : "
  call print_num 

  call new_line
  call print_line
               
  call back_to_menu 
  

ExponentNum: 
  call clear_screen 

  printn "----------------"
  printn " Exponent/Power "   
  printn "----------------"  

  redo1:
  print "Enter a Number  : "
  call scan_num
  mov bx, cx
  
  cmp bx, 9
  jg overFlow1
     
  mov ax, 1          
            
  printn 
  print "Enter its exponent: "
  call scan_num
                
  cmp cx, 0
  mov ax, 1                     ; if user enters 0 (cx = 0) then go-to result and print 1, 0! = 1
  je result
               
  
  PowerLoop:
    mul bx         
 
  loop PowerLoop
  
  result:
   printn 
   print "Result            : "
   call print_num_uns              
   jmp j1 
                    
  overflow1:
   printn
   print "Input out of range (please enter from 0 to 9), try again" 
   printn
   jmp redo1

  j1:  
  call new_line
  call print_line            
 call back_to_menu 


FacNum:                       
  call clear_screen 

  printn "-----------"
  printn " Factorial "   
  printn "-----------"  

  
  back:
  print "Enter a number : "
  call    scan_num              ; saves number in cx
  
  mov ax, 1                     ; last multipl
                                 
  cmp cx, 0                     ; if user enters 0 (cx = 0) then go-to result and print 1, 0! = 1
  je result1
                                ; if user enters a number greater than 8, then go-to overflow
  cmp cx, 8
  jg overflow 
  

              
  forfact:
   Mov bx, cx              
   mul bx
  loop forfact 
 
   
  result1:   
   printn
   print "Result         : "
   call print_num_uns
   jmp done
   
  
  overflow:
   call new_line 
   printn     
   printn "Result out of range!"
   printn "Use values from 0 to 8."
   call print_line    
   call new_line
   
   jmp back
         
         
  done:
   call new_line
   call print_line             
   call back_to_menu


conversions proc

  call clear_screen 

  printn "-------------"
  printn " Conversions! "   
  printn "-------------" 
  
   
  
  mov si, offset menu2
  call print_string
  redo2:
   call new_line
   call print_line  
  
   printn            
   print "Choose an operation: " 
  
   call single_input
 
   cmp choice, '1'
   je CtoF                   

  
   cmp choice, '2'
   je FtoC 
   
   cmp choice, '0'
   je tomenu                   
                       

  jne invalid1

invalid1:
 printn
 print "INVALID OPERATOR!, TRY AGAIN"
 jmp redo2

tomenu:
    call clear_screen   
    call Menu


CtoF:
 ; input in celsius (in cx register)  
  
  call clear_screen 

   
  printn " Celsius to Fahrenheit! "      
  call print_line
  call new_line
 
  printn
  print "Enter temperature in celsius : "
  call    scan_num
                             

  ; formula of celsius to fahrenheit = F =  9/ 5 * Celsius + 32  
  ; result will be saved in ax 
  mov ax, 9 
  mov bx, 5
 
  mul cx  ; multiplying before dividing because there is no decimals here 
  div bx
  add ax, 32
                
  printn
  print "Result         : "
  call print_num
 
  printn
  print "Do you want to go back to Conversions Menu?(y /n): "
  call single_input
  printn    
    
  ; if choice is Y then go to sub-menu conversion
  cmp choice, 'y' 
  je equals1  
  jne e2
  
  e2:  
   printn
   printn "Thank you for using our program!"
            
   mov ah, 4Ch     ; stop the
   int 21h         ; program 
  
   
 equals1:   
  call conversions
                   
                   
FtoC:
 ; input in Fahrenheit (in cx register)
    
  call new_line
  call print_line
  call new_line
 
  printn
  print "Enter temperature in fahrenheit : "
  call  scan_num
                             

  ; formula of celsius to fahrenheit = F =  9/ 5 * Celsius + 32  

  ; to this formula: c = (f - 32) * 5 / 9

    
  sub cx, 32
  mov ax, 5
  mul cx
  mov cx, 9
  div cx
    
  printn
  print "Result         : "
  call print_num
 
  printn
  print "Do you want to go back to Main Menu?(y /n): "
  call single_input
  printn    
    
  ; if choice is Y then go to sub-menu conversion
  cmp choice, 'y' 
  je equals2
  jne e3
  
 equals2:   
  call conversions
  
  
  
  e3:  
   printn
   printn "Thank you for using our program!"
            
   mov ah, 4Ch     ; stop the
   int 21h         ; program                      

    
  
conversions endp 

      

                              
            ;UTILITY FUNCTIONS below                  
;----------------------------------------------------;

; below procedure is used for single digit/char input
single_input proc
  
  mov ah, 1
  int 21h    
  mov choice, al    
  
  
  ret     

single_input endp 
   
   
; procedure for returning back to main menu
back_to_menu proc
  
  printn
  print "Do you want to go back to Main Menu?(y/n): "
  call single_input
  printn    
    
  ; if choice is Y then go to menu
  cmp choice, 'y' 
  je equals
  

  
  ; else if choice = N, go to exit
  cmp choice, 'n'   
  je Exit1                

  jne invalidInput 
  
  equals:
   call clear_screen
   call Menu    
                 

  invalidInput:  
   printn  
   printn "INVALID INPUT, TRY AGAIN!"
   call print_line
         
  call back_to_menu

  Exit1:    
   printn
   printn "Thank you for using our program!"
            
   mov ah, 4Ch     ; stop the
   int 21h         ; program         


back_to_menu endp
    
 
; this function prints horizontal line(------)
Print_Line proc                    
                
  lea dx, line              ; can also use mov with offset
  mov ah, 9
  int 21h
           
  ret

Print_Line endp
                      
 
; moves cursor to new line      
New_Line proc  
              
  mov dx, offset newline
  mov ah, 9
  int 21h 
  
  ret

New_Line endp



; pre-defined procedures from the emu8086.inc file
;-----------;
DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS                          
DEFINE_CLEAR_SCREEN
;-----------;

end 