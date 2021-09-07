
        .data
string:   .asciiz "Hello World"
newline: .asciiz "\n"

        .text
        .globl main
main:  
        li $v0, 4      
        la $a0, string     
        syscall         
        
		li $v0, 4
		la $a0, newline      
        syscall 
		
		li $t2,0
strlen:
		lb $t0, string($t2)
        addi $t2,$t2,1
        bne $t0,$zero,strlen		
        
		li $v0,11
		loop:
		      sub  $t2,$t2,1
			  la $t0,string($t2)
			  lb $a0,($t0)
			  
			  syscall
		
        bnez    $t2, loop
	    li   $v0, 10            
	syscall        
