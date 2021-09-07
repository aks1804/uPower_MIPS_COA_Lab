# Question 9: Converting a number represented as a string and store it as an integer
# Name: Akshat Nambiar  Roll Number: 181CO204
# Date: 24 January, 2020



.data
msg1: .asciiz "\nEnter number: "
msg2: .asciiz "Enter the number of digits: "
mem: .space 10

.text

main:
la $a0, msg2
li $v0, 4
syscall

li $v0, 5
syscall

move $a1, $v0
addi $a1, $a1, 1

la $a0, msg1
li $v0, 4
syscall


la $a0, mem
li $v0, 8
syscall



lb $t0, 0($a0)

li $t1, 0

li $t2, 10

li $t3, '0'


loopouter:
beqz $t0, exitouter

loopinner:
bne $t0, $t3, false
mult $t1, $t2
mflo $t1
move $t4, $t3
addi $t4, $t4, -48
add $t1, $t1, $t4
j exitinner

false:
beq $t3, '9', fail
addi $t3, $t3, 1
j loopinner

exitinner:
addi $a0, $a0, 1
lb $t0, 0($a0)
li $t3, '0'
j loopouter

fail:
li $v0, -1

exitouter:
move $v0, $t1


.end
