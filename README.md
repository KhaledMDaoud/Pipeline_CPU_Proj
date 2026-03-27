# Pipeline CPU Project
### **Project Overview**

Design and implement a 32-bit 5-stage pipelined processor in Verilog, supporting a subset of RISC-V-style instructions. Built core modules for instruction fetch, decode, execute, memory, and write-back, along with pipeline registers, control logic, ALU, register file, immediate generation, and branch/flush handling; verified functionality using custom testbenches and simulation waveforms

### **Requirements**
1. RISC-V Assembler 
    Build a RISC-V assembler using any high-level language. The assembler should work for the RISC-V instruction in the table below.  
 
2. Core Processor Design\
    a. Implement a limited version of a RISC-V processor supporting the instructions in the table below.\
    b. Use separate instruction and data memories: Instruction Memory (IM) at 64K x 1 byte, Data Memory (DM) at 8K x 1 byte.\
    c. The processor execution should be triggered on a positive edge.\
    d. To allow for Reading/Writing to memory and Register file during the same cycle, use the negative edge of the clock to trigger reading. 
 
3. Performance Features\n
    a. Dynamic Branch Prediction: Design a simple 2-bit predictor to enhance branching accuracy.\
    b. Report the total number of cycles and instructions executed for the program and store the results in dedicated registers.

<p align="center"><img width="601" height="632" alt="image" src="https://github.com/user-attachments/assets/160c63ee-dcef-4e3b-890a-ddae8936ab3e" /></p>
