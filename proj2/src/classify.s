.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 72
    # - If malloc fails, this function terminates the program with exit code 88
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0, 5
    beq a0, t0, start
    li a1, 72
    call exit2

start:
    addi sp, sp, -52
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
    sw s10, 44(sp)
    sw s11, 48(sp)

    lw s0, 4(a1)
    lw s1, 8(a1)
    lw s2, 12(a1)
    lw s3, 16(a1)

    mv s11, a2

	# =====================================
    # LOAD MATRICES
    # =====================================
    addi sp, sp, -8

    # Load pretrained m0
    mv a0, s0
    mv a1, sp
    addi a2, sp, 4
    call read_matrix
    mv s0, a0
    lw s4, 0(sp)
    lw s5, 4(sp)

    # Load pretrained m1
    mv a0, s1
    mv a1, sp
    addi a2, sp, 4
    call read_matrix
    mv s1, a0
    lw s6, 0(sp)
    lw s7, 4(sp)

    # Load input matrix
    mv a0, s2
    mv a1, sp
    addi a2, sp, 4
    call read_matrix
    mv s2, a0
    lw s8, 0(sp)
    lw s9, 4(sp)

    addi sp, sp, 8

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    li a0, 4
    mul a0, a0, s4
    mul a0, a0, s9
    call malloc
    beq a0, zero, err_malloc
    mv s10, a0

    mv a0, s0
    mv a1, s4
    mv a2, s5
    mv a3, s2
    mv a4, s8
    mv a5, s9
    mv a6, s10
    call matmul

    mv a0, s10
    mul a1, s4, s9
    call relu

    li a0, 4
    mul a0, a0, s6
    mul a0, a0, s9
    call malloc
    beq a0, zero, err_malloc

    mv t0, a0

    mv a0, s1
    mv a1, s6
    mv a2, s7
    mv a3, s10
    mv a4, s4
    mv a5, s9
    mv a6, t0
    mv s7, t0 # h
    call matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    mv a0, s3
    mv a1, s7
    mv a2, s6
    mv a3, s9
    call write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s7
    mul a1, s6, s9
    call argmax

    bne s11, zero, no_print
    
    # Print classification
    mv a1, a0
    call print_int

    # Print newline afterwards for clarity
    li a1, '\n'
    call print_char

no_print:

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
    lw s10, 44(sp)
    lw s11, 48(sp)

    addi sp, sp, 52
    ret

err_malloc:
    li a1, 88
    call exit2
