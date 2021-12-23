.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================
matmul:
    blt zero, a1, check1
    addi a1, zero, 59
    call exit2
check1:
    blt zero, a2, check2
    addi a1, zero, 59
    call exit2
check2:
    blt zero, a4, check3
    addi a1, zero, 59
    call exit2
check3:
    blt zero, a5, check4
    addi a1, zero, 59
    call exit2
check4:
    beq a2, a4, outer_loop_start
    addi a1, zero, 59
    call exit2

outer_loop_start:
    addi sp, sp, -44
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6  
    addi s7, zero, 0 # i = 0

outer_loop_continue:
    beq s7, s1, outer_loop_end

    addi s8, zero, 0 # j = 0
    mv s9, s3 # p2 = v2

inner_loop_start:
    beq s8, s5, inner_loop_end
    mv a0, s0
    mv a1, s9
    mv a2, s2
    li a3, 1
    mv a4, s5
    call dot
    sw a0, 0(s6)

    addi s6, s6, 4
    addi s9, s9, 4
    addi s8, s8, 1
    j inner_loop_start

inner_loop_end:
    addi t0, zero, 4
    mul t0, t0, s2
    add s0, s0, t0 # v1 = v1 + 4 * r1
    addi s7, s7, 1
    j outer_loop_continue

outer_loop_end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)

    addi sp, sp, 44

    ret
