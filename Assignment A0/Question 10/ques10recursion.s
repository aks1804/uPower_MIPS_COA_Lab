# Question 10(a): Find the nth fibonacci number using recursion
# Name : Akshat Nambiar    Roll Number: 181CO204
# Date: 24 January, 2020

.data
msg1: .asciiz "Enter the sequence index(series starts with 1) = "
msg2: .asciiz "nth:"
msg3: .asciiz "(n+1)th:"
message: .asciiz "nth:0\n(n+1)th:1"
newline : .asciiz "\n"

.text
.globl main
    main:
        li $v0, 4
        la $a0, msg1
        syscall


        li $v0, 5
        syscall

        beq $v0, 0, equalToZero


        move $a0, $v0
        addi $a2,$a0,1
        jal fibonacci
        move $a1, $v0

        move $a0,$a2
        jal fibonacci
        move $a2,$v0


        li $v0, 4
        la $a0, msg2
        syscall


        li $v0, 1
        move $a0, $a1
        syscall


        li $v0, 4
        la $a0, newline
        syscall


        li $v0,4
        la $a0, msg3
        syscall


        li $v0, 1
        move $a0, $a2
        syscall


        li $v0, 10
        syscall

        .end main




        fibonacci:

        addi $sp, $sp, -12
        sw $ra, 8($sp)
        sw $s0, 4($sp)
        sw $s1, 0($sp)
        move $s0, $a0
        li $v0, 1
        ble $s0, 0x2, fibonacciExit
        addi $a0, $s0, -1
        jal fibonacci
        move $s1, $v0
        addi $a0, $s0, -2
        jal fibonacci
        add $v0, $s1, $v0
        fibonacciExit:

        lw $ra, 8($sp)
        lw $s0, 4($sp)
        lw $s1, 0($sp)
        addi $sp, $sp, 12
        jr $ra


        equalToZero:
        li $v0, 4
        la $a0, message
        syscall

        li $v0,10
        syscall
.end
