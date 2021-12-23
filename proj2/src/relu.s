.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# ==============================================================================
relu:
    blt zero, a0, loop_start

    # exit 57
    addi a1, x0, 57
    call exit2

loop_start:
    beq a1, zero, loop_end
    lw a2, 0(a0)
    bge a2, zero, loop_continue
    addi a2, zero, 0
    sw a2, 0(a0)

loop_continue:
    addi a0, a0, 4
    addi a1, a1, -1
    j loop_start

loop_end:
	ret
