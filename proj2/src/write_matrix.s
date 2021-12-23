.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 92
# ==============================================================================
write_matrix:
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    # fopen
    mv a1, s0
    li a2, 1
    call fopen
    li t0, -1
    bne a0, t0, fopen_success
    li a1, 89
    call exit2

fopen_success:
    mv s4, a0 # file
    addi sp, sp, -4

    sw s2, 0(sp)
    mv a1, s4
    mv a2, sp
    li a3, 1
    li a4, 4
    call fwrite
    li t0, 1
    bne a0, t0, err_fwrite

    sw s3, 0(sp)
    mv a1, s4
    mv a2, sp
    li a3, 1
    li a4, 4
    call fwrite
    li t0, 1
    bne a0, t0, err_fwrite

    mv a1, s4
    mv a2, s1
    mul s2, s2, s3
    mv a3, s2
    li a4, 4
    call fwrite
    bne a0, s2, err_fwrite

    mv a1, s4
    call fclose
    bne a0, zero, err_fclose

    addi sp, sp, 4

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)

    addi sp, sp, 24
    ret

err_fwrite:
    li a1, 92
    call exit2

err_fclose:
    li a1, 90
    call exit2
