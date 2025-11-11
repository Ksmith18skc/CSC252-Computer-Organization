/* File: sim4.c
 * Author: Kory Smith
 * Purpose: Create a single cycle CPU
 */
#include "sim5.h"

// this function extracts the opcode, rs, rt, rd, shamt, funct, imm16, and address
// fields from the instruction and stores them in the fieldsOut structure.
void extract_instructionFields(WORD instruction, InstructionFields *fieldsOut)
{
	// just fill it all in with bit masking and shifting
	fieldsOut->opcode = (instruction & 0xfc000000) >> 26;
	fieldsOut->rs = (instruction & 0x03e00000) >> 21;
	fieldsOut->rt = (instruction & 0x001f0000) >> 16;
	fieldsOut->rd = (instruction & 0x0000f800) >> 11;
	fieldsOut->shamt = (instruction & 0x000007c0) >> 6;
	fieldsOut->funct = (instruction & 0x0000003f);
	fieldsOut->imm16 = (instruction & 0x0000ffff);
	fieldsOut->imm32 = signExtend16to32(fieldsOut->imm16);
	fieldsOut->address = (instruction & 0x03ffffff);
}

// this function asks if a stall is required. If you need to stall the ID phase,
// return 1; if not, then return 0.
int IDtoIF_get_stall(InstructionFields *fields, ID_EX *old_idex, EX_MEM *old_exmem)
{
	int temp;
	if (old_idex->regDst == 0)
	{
		temp = old_idex->rt;
	}
	else
	{
		temp = old_idex->rd;
	}
	// Check for hazards and stall conditions
	if (old_idex->regWrite && old_idex->memToReg)
	{ // if i need to do save to register
		if (fields->rs == temp)
		{ // if equal
			return 1;
		}
		if (fields->opcode == 0 && (temp == fields->rt))
		{ // If rt
			return 1;
		}
	}

	if (old_exmem->regWrite && old_exmem->memToReg)
	{ // If Rt = lw
		if (fields->rs == old_exmem->writeReg)
		{ // if rs = old register
			return 1;
		}
		if (fields->opcode == 0 && (old_exmem->writeReg == fields->rt))
		{ // check rt register (I-type)
			return 1;
		}
	}

	if (fields->opcode == 43 && old_exmem->regWrite)
	{ // If SW
		if (fields->rt == old_exmem->writeReg)
		{ // If rt = old register
			if (temp != fields->rt || !old_idex->regWrite)
			{
				return 1;
			}
		}
	}
	return 0;
}

// this function asks if a branch or jump is taken. If the branch or jump is taken
// the the PC will jump to the destination address.
int IDtoIF_get_branchControl(InstructionFields *fields, WORD rsVal, WORD rtVal)
{

	int result = 0;
	// Check for a branch instruction
	if (fields->opcode == 0x04 || fields->opcode == 0x05)
	{
		if (fields->opcode == 0x04 && rsVal == rtVal)
		{
			result = 1; // jump to relative address
		}
		if (fields->opcode == 0x05 && rsVal != rtVal)
		{
			result = 1; // jump to relative address
		}
	}

	// Check for a jump instruction
	if (fields->opcode == 0x02)
	{
		result = 2; // jump to absolute address
	}

	return result;
}

// This asks you to calculate the address that you would jump to if you
// perform a conditional branch (BEQ,BNE).
WORD calc_branchAddr(WORD pcPlus4, InstructionFields *fields)
{
	WORD branchAdder = (fields->imm32 << 2) + pcPlus4;
	return branchAdder;
}

// This asks you to calculate the address that you would jump to if you
// perform an unconditional branch (JUMP).
WORD calc_jumpAddr(WORD pcPlus4, InstructionFields *fields)
{
	WORD jumpAdder = (fields->address << 2) | ((pcPlus4 >> 28) << 28);
	return jumpAdder;
}

// This function is used to set the values of the ID/EX pipeline register to 0 for a stall cycle
void setStall(ID_EX *new_idex)
{

	new_idex->ALU.op = 0;
	new_idex->regDst = 0;
	new_idex->regWrite = 0;
	new_idex->memRead = 0;
	new_idex->memWrite = 0;
	new_idex->memToReg = 0;
	new_idex->ALUsrc = 0;
	new_idex->ALU.bNegate = 0;
	new_idex->extra1 = 0;
	new_idex->extra2 = 0;
	new_idex->extra3 = 0;
	new_idex->rs = 0;
	new_idex->rt = 0;
	new_idex->rd = 0;
	new_idex->rsVal = 0;
	new_idex->rtVal = 0;
	new_idex->imm16 = 0;
	new_idex->imm32 = 0;

	return;
}

// execute_ID function is used to determine the operation of the instruction and set the values of the ID/EX pipeline register
int execute_ID(int IDstall, InstructionFields *fieldsIn, WORD pcPlus4, WORD rsVal, WORD rtVal, ID_EX *new_idex)
{

	// Copy values to next pipeline register
	new_idex->rs = fieldsIn->rs;
	new_idex->rt = fieldsIn->rt;
	new_idex->rd = fieldsIn->rd;
	new_idex->rsVal = rsVal;
	new_idex->rtVal = rtVal;
	new_idex->imm16 = fieldsIn->imm16;
	new_idex->imm32 = fieldsIn->imm32;

	WORD opcode = fieldsIn->opcode;
	WORD funct = fieldsIn->funct;

	// Initialize to 0
	new_idex->extra1 = 0;
	new_idex->extra2 = 0;
	new_idex->extra3 = 0;
	new_idex->ALUsrc = 0;
	new_idex->ALU.bNegate = 0;
	new_idex->ALU.op = 0;
	new_idex->memRead = 0;
	new_idex->memWrite = 0;
	new_idex->memToReg = 0;
	new_idex->regDst = 0;
	new_idex->regWrite = 0;

	// Check for stall
	if (IDstall)
	{

		// printf("WTFFF\n");

		setStall(new_idex);
		return 1;
	}

	// ADD
	else if (opcode == 0 && (funct == 32 || funct == 33))
	{
		new_idex->ALU.op = 2;
		new_idex->regDst = 1;
		new_idex->regWrite = 1;
		return 1;
	}

	// ADDI
	else if (opcode == 8 || opcode == 9)
	{
		new_idex->ALUsrc = 1;
		new_idex->ALU.op = 2;
		new_idex->regWrite = 1;
		return 1;
	}

	// SUB
	else if (opcode == 0 && (funct == 34 || funct == 35))
	{
		new_idex->ALU.bNegate = 1;
		new_idex->ALU.op = 2;
		new_idex->regDst = 1;
		new_idex->regWrite = 1;
		return 1;
	}

	// AND
	else if (opcode == 0 && funct == 36)
	{
		new_idex->regDst = 1;
		new_idex->regWrite = 1;
		return 1;
	}

	// XOR
	else if (opcode == 0 && funct == 38)
	{
		new_idex->ALU.op = 4;
		new_idex->regWrite = 1;
		new_idex->regDst = 1;
		return 1;
	}

	// NOR
	else if (opcode == 0 && funct == 39)
	{
		new_idex->ALU.op = 1;
		new_idex->regDst = 1;
		new_idex->regWrite = 1;
		new_idex->extra1 = 1;
		return 1;
	}

	// OR
	else if (opcode == 0 && funct == 37)
	{
		new_idex->ALU.op = 1;
		new_idex->regDst = 1;
		new_idex->regWrite = 1;
		return 1;
	}

	// SLT
	else if (opcode == 0 && funct == 42)
	{
		new_idex->ALU.bNegate = 1;
		new_idex->ALU.op = 3;
		new_idex->regDst = 1;
		new_idex->regWrite = 1;
		return 1;
	}

	// SLTI
	else if (opcode == 10)
	{
		new_idex->ALUsrc = 1;
		new_idex->ALU.bNegate = 1;
		new_idex->ALU.op = 3;
		new_idex->regWrite = 1;
		return 1;
	}

	// SW
	else if (opcode == 43)
	{
		new_idex->ALUsrc = 1;
		new_idex->ALU.op = 2;
		new_idex->memWrite = 1;
		return 1;
	}

	// LW
	else if (opcode == 35)
	{
		new_idex->ALUsrc = 1;
		new_idex->ALU.op = 2;
		new_idex->memRead = 1;
		new_idex->memToReg = 1;
		new_idex->regWrite = 1;
		return 1;
	}

	// BNE
	else if (opcode == 5)
	{
		new_idex->extra1 = 1;
		new_idex->rs = 0;
		new_idex->rt = 0;
		new_idex->rd = 0;
		new_idex->rsVal = 0;
		new_idex->rtVal = 0;
		return 1;
	}

	// JUMP
	else if (opcode == 2)
	{
		new_idex->rs = 0;
		new_idex->rt = 0;
		new_idex->rd = 0;
		new_idex->rsVal = 0;
		new_idex->rtVal = 0;
		return 1;
	}

	// BEQ
	else if (opcode == 4)
	{
		new_idex->rs = 0;
		new_idex->rt = 0;
		new_idex->rd = 0;
		new_idex->rsVal = 0;
		new_idex->rtVal = 0;
		return 1;
	}

	// ANDI
	else if (opcode == 12)
	{
		new_idex->ALUsrc = 2;
		new_idex->regWrite = 1;
		return 1;
	}

	// ORI
	else if (opcode == 13)
	{
		new_idex->ALUsrc = 2;
		new_idex->ALU.op = 1;
		new_idex->regWrite = 1;
		return 1;
	}

	// LUI
	else if (opcode == 15)
	{
		new_idex->ALUsrc = 2;
		new_idex->ALU.op = 4;
		new_idex->regWrite = 1;
		new_idex->extra2 = 1;
		return 1;
	}

	// NOP
	else if (opcode == 0 && funct == 0)
	{
		new_idex->ALU.op = 5;
		new_idex->regDst = 1;
		new_idex->regWrite = 1;
		new_idex->rs = 0;
		new_idex->rt = 0;
		new_idex->rd = 0;
		new_idex->rsVal = 0;
		new_idex->imm16 = 0;
		new_idex->imm32 = 0;
		return 1;
	}

	// Otherwise we have an invalid instruction
	return 0;
}

// This function returns the value which is to be delivered to the ALU input 1
WORD EX_getALUinput1(ID_EX *in, EX_MEM *old_exMem, MEM_WB *old_memWb)
{
	//  If old_exMem write to rs reg
	if (old_exMem->regWrite && old_exMem->writeReg == in->rs)
	{
		return old_exMem->aluResult;
	}

	// If old_memWb write to rs reg
	if (old_memWb->regWrite && old_memWb->writeReg == in->rs)
	{
		return old_memWb->aluResult;
	}

	return in->rsVal;
}

// This function returns the value which is to be delivered to the ALU input 2
WORD EX_getALUinput2(ID_EX *in, EX_MEM *old_exMem, MEM_WB *old_memWb)
{
	// If ALUsrc is 1 then we know we have an immediate value. (I-type)
	if (in->ALUsrc == 1)
	{
		return in->imm32;
	}

	// If alusrc = 2 then andi
	if (in->ALUsrc == 2)
	{
		return in->imm16;
	}

	// If old_exMem wrote to the same register as rt
	if (old_exMem->regWrite && old_exMem->writeReg == in->rt)
	{
		return old_exMem->aluResult;
	}

	// If old_memWb wrote to the same register as rt
	if (old_memWb->regWrite && old_memWb->writeReg == in->rt)
	{
		return old_memWb->aluResult;
	}

	return in->rtVal;
}

// This function implements the core of the EX phase. It has a pointer to the
// ID/EX pipeline register (which it must not modify), the two input values
// (see above), and a pointer to the EX/MEM pipeline register (which it
// must fill).
void execute_EX(ID_EX *in, WORD input1, WORD input2, EX_MEM *new_exMem)
{

	// copy values to next pipeline register

	new_exMem->rt = in->rt;
	new_exMem->rtVal = in->rtVal;
	new_exMem->regWrite = in->regWrite;
	new_exMem->aluResult = 0;
	new_exMem->extra1 = in->extra1;
	new_exMem->extra2 = in->extra2;
	new_exMem->extra3 = in->extra3;
	new_exMem->memToReg = in->memToReg;
	new_exMem->memRead = in->memRead;
	new_exMem->memWrite = in->memWrite;

	// Get instruction format (R, I, J)
	if (in->ALUsrc == 1)
	{
		new_exMem->writeReg = in->rt;
	}
	else
	{
		if (in->ALUsrc == 2)
		{
			new_exMem->writeReg = in->rt;
		}
		else
		{
			new_exMem->writeReg = in->rd;
		}
	}

	// lui
	if (in->extra2)
	{
		new_exMem->aluResult = in->imm16 << 16;
		return;
	}

	// Now we check if operation is 3 to set result less than.
	if (in->ALU.op == 3)
	{
		new_exMem->aluResult = input1 < input2;
	}

	// If operation is not 3 then we know either it is
	// and, or, nor, or adding.
	else
	{
		// If we have a negate then we need to negate the input.
		if (in->ALU.bNegate)
		{
			input2 *= -1;
		}

		// (AND)
		if (in->ALU.op == 0)
		{
			new_exMem->aluResult = input1 & input2;
		}

		// (OR)
		if (in->ALU.op == 1)
		{
			//  (NOR)
			if (in->extra1)
			{
				new_exMem->aluResult = ~(input1 | input2);
			}

			// (OR)
			else
			{
				new_exMem->aluResult = (input1 | input2);
			}
		}

		// (ADD)
		if (in->ALU.op == 2)
		{
			new_exMem->aluResult = input1 + input2;
		}

		//(XOR)
		if (in->ALU.op == 4)
		{
			new_exMem->aluResult = input1 ^ input2;
		}
	}
}

// Memory stage, which reads or writes data from or to memory.
// Only update is that it must handle SW data forwarding.

void execute_MEM(EX_MEM *in, MEM_WB *old_memWb, WORD *mem, MEM_WB *new_memwb)
{
	new_memwb->aluResult = in->aluResult;
	new_memwb->memToReg = in->memToReg;
	new_memwb->regWrite = in->regWrite;
	new_memwb->writeReg = in->writeReg;
	new_memwb->extra1 = in->extra1;
	new_memwb->extra2 = in->extra1;
	new_memwb->extra3 = in->extra3;
	if (in->memWrite == 1)
	{ // If sw

		if (old_memWb->regWrite == 1 && old_memWb->writeReg == in->rt)
		{ // forward data
			mem[in->aluResult / 4] = old_memWb->aluResult;
			if (old_memWb->memToReg == 1)
			{
				mem[in->aluResult / 4] = old_memWb->memResult;
			}
		}
		else
		{
			mem[in->aluResult / 4] = in->rtVal;
		}
	}
	if (in->memRead == 1)
	{ // If lw
		new_memwb->memResult = mem[in->aluResult / 4];
	}
	else
	{
		new_memwb->memResult = 0;
	}
}

//  Write back stage, which writes the result of the instruction to the register file.
void execute_WB(MEM_WB *in, WORD *regs)
{

	if (in->regWrite)
	{
		if (in->memToReg)
		{
			regs[in->writeReg] = in->memResult;
		}

		else
		{
			regs[in->writeReg] = in->aluResult;
		}
	}
}
