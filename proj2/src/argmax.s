.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# =================================================================
argmax:
    blt zero, a0, loop_start

    # exit 57
    addi a1, zero, 57
    call exit2

loop_start:
    lw a3, 0(a0) # max = v[0]
    addi a0, a0, 4 # v += 1
    addi a2, zero, 1 # i = 1
    addi a4, zero, 0 # max_idx = 0

loop_continue:
    beq a1, a2, loop_end
    lw a5, 0(a0)
    bge a3, a5, else
    add a3, zero, a5
    add a4, zero, a2
else:
    addi a0, a0, 4
    addi a2, a2, 1
    j loop_continue

loop_end:
    add a0, zero, a4
    ret
