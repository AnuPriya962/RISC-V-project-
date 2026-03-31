# =========================================================
# COA Project Demonstration Program (Improved Version)
# Concepts:
# 1. Instruction execution
# 2. Pipeline hazards (RAW)
# 3. Cache behavior (sequential vs strided)
# 4. Branching
# 5. Trap using ECALL
# =========================================================

.data
array:  .word 5,10,15,20,25,30,35,40
result1: .word 0
result2: .word 0

.text
.globl main

main:

# ---------------------------------------------------------
# Part 1: Basic Instruction Execution
# ---------------------------------------------------------
addi x1, x0, 10
addi x2, x0, 20
add  x3, x1, x2      # x3 = 30

# ---------------------------------------------------------
# Part 2: Strong Pipeline Hazard Chain
# (Observe stalls / forwarding clearly)
# ---------------------------------------------------------
add x4, x3, x1
add x5, x4, x2
add x6, x5, x3
add x7, x6, x4
add x8, x7, x5       # deeper dependency chain

# ---------------------------------------------------------
# Part 3A: Sequential Memory Access (Good Cache)
# ---------------------------------------------------------
la x10, array
addi x11, x0, 8
addi x12, x0, 0

seq_loop:
lw x13, 0(x10)
add x12, x12, x13
addi x10, x10, 4     # next element (sequential)
addi x11, x11, -1
bne x11, x0, seq_loop

la x14, result1
sw x12, 0(x14)

# ---------------------------------------------------------
# Part 3B: Strided Access (Worse Cache Behavior)
# ---------------------------------------------------------
la x10, array
addi x11, x0, 4
addi x12, x0, 0

stride_loop:
lw x13, 0(x10)
add x12, x12, x13
addi x10, x10, 8     # skip elements (stride = 2)
addi x11, x11, -1
bne x11, x0, stride_loop

la x14, result2
sw x12, 0(x14)

# ---------------------------------------------------------
# Part 4: Arithmetic Workload (Branch + Loop)
# Factorial-like computation
# ---------------------------------------------------------
addi x15, x0, 5
addi x16, x0, 1

work_loop:
mul x16, x16, x15
addi x15, x15, -1
bne x15, x0, work_loop

# ---------------------------------------------------------
# Part 5: Trap / Interrupt Demonstration
# ---------------------------------------------------------
addi x17, x0, 1      # prepare value before trap
ecall                # trigger trap

# execution resumes after trap
addi x18, x17, 99
add  x19, x18, x3

# ---------------------------------------------------------
# End Program (Infinite loop)
# ---------------------------------------------------------
end:
j end
