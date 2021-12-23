.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================
dot:
    blt zero, a2, check1
    addi a1, zero, 57
    call exit2

check1:
    blt zero, a3, check2
    addi a1, zero, 58
    call exit2

check2:
    blt zero, a4, loop_start
    addi a1, zero, 58
    call exit2

loop_start:
    addi a5, zero, 0 # sum = 0
    add a6, zero, a0 # p1 = v1
    add a7, zero, a1 # p2 = v2

loop_continue:
    beq a2, zero, loop_end

    # sum += *p1 * *p2
    lw t1, 0(a6)
    lw t2, 0(a7)
    mul t1, t1, t2
    add a5, a5, t1

    li t1, 4
    mul t1, t1, a3
    add a6, a6, t1

    li t1, 4
    mul t1, t1, a4
    add a7, a7, t1

    addi a2, a2, -1

    j loop_continue

loop_end:
    mv a0, a5
    ret

# loop_start:
#     li t0, 0    # t0 is the i in the loop
#     li t4, 0    # t4 is the result to return

# loop_continue:
#     bge t0, a2, loop_end
#     mul t1, t0, a3  # the offset of v0
#     mul t2, t0, a4  # the offset of v1
#     add t1, t1, a0  # the address of v0[i]
#     add t2, t2, a1  # the address of v1[i]
#     lw t1, 0(t1)    # the value of v0[i]
#     lw t2, 0(t2)    # the value of v1[i]
#     mul t3, t1, t2  # t3 = t1 * t2
#     add t4, t3, t4  # result = result + t3
#     addi t0, t0, 1  # t0 = t0 + 1
#     j loop_continue

# loop_end:
#     mv a0, t4
    
#     ret
