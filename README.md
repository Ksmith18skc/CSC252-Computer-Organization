# CSC252 - Computer Organization

This repository contains coursework from **CSC252: Computer Organization** at the University of Arizona. The course covers fundamental concepts in computer architecture, digital logic design, assembly language programming, and CPU simulation.

## 📚 Course Overview

CSC252 explores the organization and architecture of computer systems, including:
- **Assembly Language Programming** (MIPS)
- **Digital Logic Design** and Circuit Simulation
- **CPU Architecture** and Single-Cycle Implementation
- **Arithmetic Logic Units (ALUs)**
- **Memory Organization** and Data Representation
- **Instruction Set Architecture (ISA)**

## 📁 Repository Structure

```
CSC252/
├── Asms/           # Assembly Programming Assignments
│   ├── asm1/       # MIPS assembly fundamentals
│   ├── asm2/       # Advanced MIPS programming
│   ├── asm3/       # Control flow and functions
│   ├── asm4/       # Memory operations
│   ├── asm5/       # Complex algorithms
│   └── asm6/       # ROT cipher implementation
│
└── Sims/           # Hardware Simulation Projects
    ├── Sim1/       # Basic logic gates and circuits
    ├── sim2/       # Adder circuits (Half/Full Adders)
    ├── sim3/       # ALU implementation
    ├── Sim4/       # Single-cycle CPU simulation (C)
    └── Sim5/       # Advanced CPU features
```

## 🔧 Assignments

### Assembly Programming (MIPS)

The **Asms** directory contains six MIPS assembly language assignments demonstrating various programming concepts:

1. **asm1** - Introduction to MIPS assembly
   - Data declarations and string handling
   - Conditional logic and branching
   - Stack frame management
   - *File: `asm1.s`*

2. **asm2** - Intermediate MIPS programming
   - Advanced control structures
   - Function calls and returns
   - *File: `asm2.s`*

3. **asm3** - Complex control flow
   - Nested loops and conditionals
   - Memory addressing modes
   - *File: `asm3.s`*

4. **asm4** - Memory operations
   - Load/store instructions
   - Array manipulation
   - *File: `asm4.s`*

5. **asm5** - Algorithm implementation
   - Efficient coding techniques
   - Register optimization
   - *File: `asm5.s`*

6. **asm6** - ROT Cipher
   - String manipulation
   - Character encoding/rotation
   - Video demonstration included
   - *Files: `ROT.s`, `Recording__5.mp4`*

### Hardware Simulations

The **Sims** directory contains five simulation projects implementing digital logic and CPU components:

#### **Sim1** - Digital Logic Fundamentals (Java)
- Implementation of basic logic gates
- Two's complement arithmetic
- Binary addition circuits
- Wire and gate abstractions
- *Files: Various `.java` gate implementations*

#### **sim2** - Adder Circuits (Java)
- Half Adder implementation
- Full Adder implementation  
- N-bit ripple-carry adder (AdderX)
- *Files: `Sim2_HalfAdder.java`, `Sim2_FullAdder.java`, `Sim2_AdderX.java`*

#### **sim3** - Arithmetic Logic Unit (Java)
- Complete ALU design
- ALU element implementation
- 8-to-1 multiplexer
- Multiple arithmetic and logic operations
- *Files: `Sim3_ALU.java`, `Sim3_ALUElement.java`, `Sim3_MUX_8by1.java`*

#### **Sim4** - Single-Cycle CPU (C)
- Complete single-cycle MIPS CPU implementation
- Instruction fetch and decode
- Control unit design
- ALU integration
- Register file management
- Memory access (load/store)
- Support for multiple instruction types:
  - R-type (ADD, SUB, AND, OR, SLT, etc.)
  - I-type (ADDI, ANDI, ORI, BEQ, BNE, LW, SW)
  - J-type (J)
- *File: `sim4.c`*
- *Test files included for instruction validation*
- **Score: 95/100**

#### **Sim5** - Advanced CPU Features (C)
- Extended CPU functionality
- Pipeline or cache simulation (likely)
- *File: `sim5.c`*

## 🛠️ Technologies & Languages

- **Assembly**: MIPS Assembly Language
- **Java**: Logic gate and circuit simulations (Sim1-3)
- **C**: CPU simulation and implementation (Sim4-5)
- **Tools**: MIPS assembler/simulator, Java compiler

## 📊 Performance

Based on metadata files:
- **Sim4 Score**: 95.0/100
- **sim2 Score**: 95.0/100
- Submissions completed throughout Spring 2024

## 👤 Author

**Kory M Smith**  
Email: korysmith@arizona.edu  
University of Arizona

## 📝 Notes

- All `.txt` files are text copies of corresponding source files (`.s`, `.java`, `.c`)
- Some assignments include PDF reports documenting implementation details
- Test files (`.out`) demonstrate expected outputs for CPU simulations
- Video demonstrations included for certain assignments (asm6)

## 🎓 Course Context

This coursework was completed as part of the Computer Science curriculum at the University of Arizona. The projects demonstrate understanding of:
- Low-level programming and optimization
- Hardware description and simulation
- Computer architecture principles
- Digital logic design
- CPU datapath and control unit design

---

*This repository serves as a portfolio of computer organization fundamentals and low-level system programming skills.*
