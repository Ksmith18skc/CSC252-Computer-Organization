/* File: sim4.c
 * Author: Kory Smith
 * Purpose: Create a single cycle CPU
 */
#include "sim4.h"

WORD getInstruction(WORD curPC, WORD *instructionMemory)
{
	return instructionMemory[curPC >> 2];
}

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

// fill the control unit with the appropriate values based on the instruction
// return 1 if the instruction is valid, 0 if it is invalid (e.g. an invalid opcode)
int fill_CPUControl(InstructionFields *fields, CPUControl *controlOut)
{

	// check for invalid instruction
	if (!(fields->opcode == 0x02 || fields->opcode == 0x0d || fields->opcode == 0x04 || fields->opcode == 0x05 || fields->opcode == 0x08 || fields->opcode == 0x09 || fields->opcode == 0x0a || fields->opcode == 0x0c || fields->opcode == 0x0e || fields->opcode == 0x23 || fields->opcode == 0x2b || fields->opcode == 0x00 && (fields->funct == 32 || fields->funct == 33 || fields->funct == 34 || fields->funct == 35 || fields->funct == 36 || fields->funct == 37 || fields->funct == 42 || fields->funct == 26 || fields->funct == 38 || fields->funct == 0x00)))
		return 0;
	// ALU src
	if (fields->opcode == 0x08 || fields->opcode == 0x09 || fields->opcode == 0x0a || fields->opcode == 0x0d || fields->opcode == 0x0c || fields->opcode == 0x23 || fields->opcode == 0x2b)
	{
		controlOut->ALUsrc = 1;
	}
	else
	{
		controlOut->ALUsrc = 0;
	}

	// alu op
	if ((fields->opcode == 0x00 && fields->funct == 37) || fields->opcode == 0x0d)
	{
		controlOut->ALU.op = 1;
	}
	else if (fields->opcode == 0x08 || fields->opcode == 0x05 || fields->opcode == 0x23 || fields->opcode == 0x2b || fields->opcode == 0x04 || fields->opcode == 0x09)
	{
		controlOut->ALU.op = 2;
	}
	else if (fields->opcode == 0x00 && (fields->funct == 32 || fields->funct == 34 || fields->funct == 35 || fields->funct == 33))
	{
		controlOut->ALU.op = 2;
	}
	else if (fields->opcode == 0x0a || (fields->opcode == 0x00 && fields->funct == 42))
	{
		controlOut->ALU.op = 3;
	}
	else if (fields->opcode == 0x00 && fields->funct == 38)
	{
		controlOut->ALU.op = 4;
	}
	else
	{

		controlOut->ALU.op = 0;
	}

	// bnegate
	if (fields->opcode == 0x0a || fields->opcode == 0x04 || fields->opcode == 0x05)
	{
		controlOut->ALU.bNegate = 1;
	}
	else if (fields->opcode == 0x00 && (fields->funct == 34 || fields->funct == 35 || fields->funct == 42))
	{
		controlOut->ALU.bNegate = 1;
	}

	else
	{
		controlOut->ALU.bNegate = 0;
	}

	// memread
	if (fields->opcode == 0x23)
	{
		controlOut->memRead = 1;
	}
	else
	{
		controlOut->memRead = 0;
	}

	// memwrite
	if (fields->opcode == 0x2b)
	{
		controlOut->memWrite = 1;
	}
	else
	{
		controlOut->memWrite = 0;
	}

	// mem to reg
	if (fields->opcode == 0x23)
	{
		controlOut->memToReg = 1;
	}
	else
	{
		controlOut->memToReg = 0;
	}

	// regdst
	if (fields->opcode == 0x00 && (fields->funct == 32 || fields->funct == 35 || fields->funct == 33 || fields->funct == 34 || fields->funct == 36 || fields->funct == 37 || fields->funct == 42 || fields->funct == 26))
	{
		controlOut->regDst = 1;
	}
	else if (fields->opcode == 0x00 && fields->funct == 38)
	{
		controlOut->regDst = 1;
	}
	else
	{
		controlOut->regDst = 0;
	}

	// regwrite
	if (fields->opcode == 0x08 || fields->opcode == 0x0a || fields->opcode == 0x0c || fields->opcode == 0x0d || fields->opcode == 0x23 || fields->opcode == 0x09)
	{
		controlOut->regWrite = 1;
	}
	else if (fields->opcode == 0x00 && (fields->funct == 32 || fields->funct == 33 || fields->funct == 35 || fields->funct == 34 || fields->funct == 36 || fields->funct == 37 || fields->funct == 42 || fields->funct == 26 || fields->funct == 38))
	{
		controlOut->regWrite = 1;
	}
	else
	{
		controlOut->regWrite = 0;
	}

	// branch
	if (fields->opcode == 0x04 || fields->opcode == 0x05)
	{
		controlOut->branch = 1;
	}
	else
	{
		controlOut->branch = 0;
	}

	// jump
	if (fields->opcode == 0x02)
	{
		controlOut->jump = 1;
	}
	else
	{
		controlOut->jump = 0;
	}

	// extra inst: bne
	if (fields->opcode == 0x05)
	{
		controlOut->extra1 = 1;
	}
	else
	{
		controlOut->extra1 = 0;
	}

	// extra inst: ori
	if (fields->opcode == 0x0d)
	{
		controlOut->extra3 = 1;
	}
	else
	{
		controlOut->extra3 = 0;
	}

	// extra inst: andi
	if (fields->opcode == 0x0c)
	{
		controlOut->extra2 = 1;
	}
	else
	{
		controlOut->extra2 = 0;
	}
	return 1;
}
WORD getALUinput1(CPUControl *controlIn,
				  InstructionFields *fieldsIn,
				  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
				  WORD oldPC)
{
	return rsVal;
}

WORD getALUinput2(CPUControl *controlIn,
				  InstructionFields *fieldsIn,
				  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
				  WORD oldPC)
{
	// if i instruction
	if (controlIn->ALUsrc)
	{
		if (controlIn->extra2 || controlIn->extra3)
			return fieldsIn->imm16;
		else
			return fieldsIn->imm32;
	}
	// if r instruction
	else
		return rtVal;
}

void execute_ALU(CPUControl *controlIn, WORD aluIn1, WORD aluIn2, ALUResult *aluResultOut)
{

	// if (controlIn->ALUsrc) {
	//     aluIn2 = signExtend16to32(aluIn2);
	// }

	// if or
	if (controlIn->ALU.op == 1)
	{
		aluResultOut->result = aluIn1 | aluIn2;
	}
	// if add and sub if binver is on
	else if (controlIn->ALU.op == 2)
	{
		if (controlIn->ALU.bNegate)
			aluResultOut->result = aluIn1 + ~aluIn2 + 1;
		else
			aluResultOut->result = aluIn1 + aluIn2;
	}
	// if slt
	else if (controlIn->ALU.op == 3)
	{
		aluResultOut->result = aluIn1 < aluIn2;
	}

	// if xor
	else if (controlIn->ALU.op == 4)
	{
		aluResultOut->result = aluIn1 ^ aluIn2;
	}
	// if and
	else if (controlIn->ALU.op == 0)
	{
		aluResultOut->result = aluIn1 & aluIn2;
	}

	else
	{
		aluResultOut->result = 0;
	}

	if (aluResultOut->result == 0)
	{
		aluResultOut->zero = 1;
	}
	else
	{
		aluResultOut->zero = 0;
	}

	if (controlIn->extra3)
	{
		aluResultOut->result = aluIn1 | aluIn2;
	}

	// if bne, reverse alu's zero output, if not, set it to result
	if (controlIn->extra1 == 1)
		aluResultOut->zero = (aluResultOut->result);
	else
		aluResultOut->zero = !(aluResultOut->result);

	return;
}

void execute_MEM(CPUControl *controlIn, ALUResult *ALUResultIn, WORD rsVal, WORD rtVal, WORD *memory, MemResult *outResult)
{

	// lw instruction
	int immediate = ALUResultIn->result;
	if (controlIn->memRead == 1)
		outResult->readVal = memory[immediate / 4];
	if (controlIn->memRead == 0)
		outResult->readVal = 0;

	// sw instruction
	if (controlIn->memWrite)
	{
		memory[ALUResultIn->result >> 2] = rtVal;
	}
}

WORD getNextPC(InstructionFields *fields, CPUControl *controlIn, int aluZero,
			   WORD rsVal, WORD rtVal,
			   WORD oldPC)
{
	WORD pcplus4 = oldPC + 4;
	// jump
	if (controlIn->jump)
	{
		WORD tmp = fields->address << 2;
		tmp = tmp + (pcplus4 & 0xf0000000);
		return tmp;
	}
	// branch
	if (controlIn->branch && aluZero)
	{
		WORD tmp = fields->imm32;
		tmp = tmp << 2;
		tmp = tmp + pcplus4;
		return tmp;
	}
	// everything else just needs pc + 4
	else
	{
		return pcplus4;
	}
}

void execute_updateRegs(InstructionFields *fields, CPUControl *controlIn,
						ALUResult *aluResultIn, MemResult *memResultIn,
						WORD *regs)
{

	if (controlIn->regWrite)
	{
		// lw
		if (controlIn->memToReg)
		{
			regs[fields->rt] = memResultIn->readVal;
		}
		// everything else gets output from alu
		else
		{
			// r instruction: update rd
			if (controlIn->regDst)
			{
				regs[fields->rd] = aluResultIn->result;
			}
			// i instruction: fill in rt
			else
			{
				regs[fields->rt] = aluResultIn->result;
			}
		}
	}
}
