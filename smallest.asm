.orig x3000 

                            
Lea r0, EnterNumber1                    ;prompt for first number, recieve user input, print out then store in r2
puts
getc
out			
add r2, r0, #0

Lea r0, EnterNumber2                    ;prompt for second number, recieve user input, print out then store in r3
puts
getc	
out		
add r3, r0, #0

Lea r0, EnterNumber3                     ;prompt for third number, recieve user input, print out then store in r4
puts
getc	
out		
add r4, r0, #0


add r5, r2, #0                                ;r5 holds the smallest number, currently number1
not r0, r2                                    ;r0 now holds negative of number1
add r0, r0, r3                                ;same as doing number2 - number1
brzp NUMBER1                                   ;if positive, number 1 is smaller.  Go to NUMBER1

add r5, r3, #0                                ;r5 is now number2 since it is smaller
not r0, r3                                    ;r0 now holds negative of number2
add r0, r0, r4                                ;same as doing number3 - number2
brzp PRINT                                     ;if positive, number 2 is smaller.  Go to PRINT

add r5, r4, #0                                ;if you've reached this point without branching, number3 must be smallest. Go to PRINT
brnzp PRINT

NUMBER1
not r0, r2                                    ;set r0 to negative of number1 again
add r0, r0, r4                                ;same as doing number3 - number1
brzp PRINT

add r5, r4, #0 

PRINT

Lea r0, PrintSmallest
puts
add r0, r5, #0 
out


Halt			;stop

EnterNumber1 .stringz "\nPlease enter number 1: "
EnterNumber2 .stringz "\nPlease enter number 2: "
EnterNumber3 .stringz "\nPlease enter number 3: "
PrintSmallest .stringz "\nThe smallest number is: "
.end
