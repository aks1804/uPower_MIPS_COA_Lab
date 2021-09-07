       .data
X:     .word 5
Y:     .word 11
SUM:   .word 0

        .text
        .globl main
main:   la $t0, X      
        la $t1, Y	
        lw $s0, 0($t0)
		lw $s1, 0($t1)
		add $s2,$s0,$s1
		
		la $t2,SUM
		sw $s2,0($t2)
       		
		li $v0,10
		syscall     
        
		.end
             
        