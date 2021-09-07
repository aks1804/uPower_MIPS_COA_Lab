.data
arr: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

.text
.globl main
main:

add $t0, $zero, $zero   
add $t1, $zero, $zero   

la  $t2, arr

loop:
slti    $t3, $t0, 10        
beq $t3, $zero, EXIT

lw  $t4, ($t2)  
addi    $t2, $t2, 4

add $t1, $t1, $t4   

addi    $t0, $t0, 1
j loop
EXIT:

add $a0, $zero, $t1     

li  $v0, 1
syscall

li  $v0, 10
syscall