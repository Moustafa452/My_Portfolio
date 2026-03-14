import random

NUM_INSTR = 512
DATA_WORDS = 16      # number of words to initialize
DATA_BASE  = 0x0     # base of data_segment

instructions = []

# -------------------------------
# Instruction helpers
def r_type(rs, rt, rd, shamt, funct):
    return (0 << 26) | (rs << 21) | (rt << 16) | (rd << 11) | (shamt << 6) | funct

def i_type(op, rs, rt, imm):
    return (op << 26) | (rs << 21) | (rt << 16) | (imm & 0xFFFF)

def j_type(op, target):
    return (op << 26) | (target & 0x03FFFFFF)

# -------------------------------
# 1) Initialize base register $1 for data segment
instructions.append(i_type(0b001000, 0, 1, DATA_BASE))  # addi $1, $0, DATA_BASE

# -------------------------------
# 2) Store initial data into data_segment
for i in range(DATA_WORDS):
    reg = (i % 6) + 2            # $2-$7
    val = i + 10
    # Load value into register
    instructions.append(i_type(0b001000, 0, reg, val))
    # Store into data memory at $1 + offset
    offset = i * 4
    instructions.append(i_type(0b101011, 1, reg, offset))   # sw

# -------------------------------
# 3) Mixed operations (R-type, LW, SW, ADDI)
for _ in range(len(instructions), NUM_INSTR-1):
    choice = random.choice(["R", "LW", "SW", "ADDI"])
    if choice == "R":
        rs = random.randint(2,7)
        rt = random.randint(2,7)
        rd = random.randint(2,7)
        funct = random.choice([0,1,2,3,4])  # ADD,SUB,AND,OR,SLT
        instructions.append(r_type(rs, rt, rd, 0, funct))
    elif choice == "LW":
        rt = random.randint(2,7)
        offset = random.randrange(0, DATA_WORDS*4, 4)
        instructions.append(i_type(0b100011, 1, rt, offset))
    elif choice == "SW":
        rt = random.randint(2,7)
        offset = random.randrange(0, DATA_WORDS*4, 4)
        instructions.append(i_type(0b101011, 1, rt, offset))
    elif choice == "ADDI":
        rt = random.randint(2,7)
        imm = random.randint(-32,32)
        instructions.append(i_type(0b001000, 1, rt, imm))

# -------------------------------
# 4) End program with jump to self (infinite loop)
pc_end = len(instructions)
instructions.append(j_type(0b000010, pc_end))

# -------------------------------
# 5) Write little-endian HEX
with open("INSTRUCTIONS.hex","w") as f:
    for instr in instructions[:NUM_INSTR]:
        for i in range(4):
            f.write(f"{(instr >> (8*i)) & 0xFF:02X}\n")
