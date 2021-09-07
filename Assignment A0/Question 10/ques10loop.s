# Question 10(a): Find the nth fibonacci number using loops
# Name : Danish Waseem   Roll Number: 181CO116
# Date: 24 January, 2020

.data
input:  .space  4
output: .word  0
output2:    .word   0
msg:    .asciiz     "1st fibonmacci number = 0 and second fibonacci number = 1. Enter n>2: "
op:     .asciiz     "The nth fibonacci number is : "
oop:    .asciiz     "\n"
op1:    .asciiz     "The (n+1)th fibonacci number is: "

.globl main
.text

main:
    la $a0, msg
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    sw $v0, input

    la $t0, input
    lw $t1, 0($t0)

    li $s0, 1
    li $s1, 2

    addi $t1, $t1, -2

    li $s0, 0
    li $s1, 1

loop:
    beq $t1, $0, done
    addi $t1, $t1, -1

    add $s2, $s0, $s1
    move $s0, $s1
    move $s1, $s2
    j loop

done:

    la $a0, op
    li $v0, 4
    syscall

    addi $a0, $s2, 0
    sw $s2, output
    li $v0, 1
    syscall

    la $a0, oop
    li $v0, 4
    syscall

    la $a0, op1
    li $v0, 4
    syscall

    add $a0, $s2, $s0
    sw $a0, output2
    li $v0, 1
    syscall

    move $v0, $s2
    move $v1, $a0

    li $a0, 0
    li $s0, 0
    li $s1, 0
    li $s2, 0


li $v0, 10
syscall


.end
