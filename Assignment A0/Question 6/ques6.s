.data

array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
sum: .word 0
messageforSum: .asciiz "Sum: "
messageforAverage: .asciiz "Average: "
newline: .asciiz "\n" 

.text
.globl main

main:
    li $a0, 10	    
    la $a1, array   
    jal sumofArray  
    sw $v0, sum

   
    la $a0, messageforSum
    li $v0, 4
    syscall

   
    lw $a0, sum
    li $v0, 1
    syscall
   
    
    li $t0, 10
    lw $t1, sum
    div $t1, $t1, $t0

   
    la $a0, newline
    li $v0, 4
    syscall

   
    la $a0, messageforAverage
    li $v0, 4
    syscall
    
   
    add $a0, $0, $t1
    li $v0, 1
    syscall

    li $v0 10
    syscall


sumofArray:
    li $t0 0 
    li $v0 0 

loop:
    lw $t1, 0($a1)
    add $v0, $v0, $t1
    addi $t0, 1
    addi $a1, 4
    bne $t0, $a0, loop
    
    jr $ra