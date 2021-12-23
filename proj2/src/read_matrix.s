.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================
read_matrix:
    addi sp, sp, -40
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

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # fopen
    mv a1, s0
    li a2, 0
    call fopen
    li t0, -1
    bne a0, t0, fopen_success
    li a1, 89
    call exit2

fopen_success:
    mv s3, a0 #file
    addi sp, sp, -4
    mv a1, s3
    mv a2, sp
    li a3, 4
    call fread
    li t0, 4
    bne a0, t0, err_fread
    lw s4, 0(sp) # row
    sw s4, 0(s1)
    
    mv a1, s3
    mv a2, sp
    li a3, 4
    call fread
    li t0, 4
    bne a0, t0, err_fread
    lw s5, 0(sp) # col
    sw s5, 0(s2)

    li a0, 4
    mul a0, a0, s4
    mul a0, a0, s5
    call malloc
    beq a0, zero, err_malloc
    mv s6, a0 # vec
    mv s7, s5 # tmp_col
    mv s8, s6 # tmp_vec

outer_loop_start:
    beq s4, zero, outer_loop_end
    mv s5, s7

inner_loop_start:
    beq s5, zero, inner_loop_end

    # fread
    mv a1, s3
    mv a2, sp
    li a3, 4
    call fread
    li t0, 4
    bne a0, t0, err_fread
    lw t0, 0(sp)
    sw t0, 0(s6)

    addi s6, s6, 4

    addi s5, s5, -1
    j inner_loop_start

inner_loop_end:
    addi s4, s4, -1
    j outer_loop_start

outer_loop_end:
    mv a1, s3
    call fclose
    bne a0, zero, err_fclose

    addi sp, sp, 4
    mv a0, s8

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

    addi sp, sp, 40
    ret

err_fread:
    li a1, 91
    call exit2

err_fclose:
    li a1, 90
    call exit2

err_malloc:
    li a1, 88
    call exit2
