// * Author: Kory Smith

public class Sim3_ALU {

	// Inputs
	public RussWire[] aluOp;
	public RussWire[] a;
	public RussWire[] b;

	public RussWire bNegate; // Control bit to negate input b
	public int x; // Number of ALU elements
	public RussWire[] result; // Output result wires
	public Sim3_ALUElement[] alu; // Array of ALU elements

	public Sim3_ALU(int x) {
		aluOp = new RussWire[3]; // Initialize ALU operation control bits array
		a = new RussWire[x]; // Initialize input a array with size x
		b = new RussWire[x]; // Initialize input b array with size x
		bNegate = new RussWire(); // Initialize bNegate control bit
		this.x = x; // Set number of ALU elements
		result = new RussWire[x]; // Initialize result array with size x
		alu = new Sim3_ALUElement[x]; // Initialize ALU elements array with size x

		// Initialize ALU operation control bits array
		for (int i = 0; i < 3; i++) {
			aluOp[i] = new RussWire();
		}

		// Initialize input a, input b, and result arrays

		for (int i = 0; i < x; i++) {
			a[i] = new RussWire();
			b[i] = new RussWire();
			result[i] = new RussWire();
			alu[i] = new Sim3_ALUElement(); // Initialize each ALU element
		}
	}

	public void execute() {
		// Setting up the first ALU which has its carryIn set to bNegate
		alu[0].aluOp[0].set(aluOp[0].get());
		alu[0].aluOp[1].set(aluOp[1].get());
		alu[0].aluOp[2].set(aluOp[2].get());
		alu[0].bInvert.set(bNegate.get());
		alu[0].a.set(a[0].get());
		alu[0].b.set(b[0].get());
		alu[0].carryIn.set(bNegate.get());
		alu[0].execute_pass1();
		for (int i = 1; i < x; i++) {
			alu[i].aluOp[0].set(aluOp[0].get());
			alu[i].aluOp[1].set(aluOp[1].get());
			alu[i].aluOp[2].set(aluOp[2].get());
			alu[i].bInvert.set(bNegate.get());
			alu[i].a.set(a[i].get());
			alu[i].b.set(b[i].get());
			alu[i].carryIn.set(alu[i - 1].carryOut.get());
			alu[i].less.set(false);
			alu[i].execute_pass1();
		}
		// Setting the less value of the first ALU to the adder result of the
		// last ALU. (Carry-Out -> Carry-In)
		alu[0].less.set(alu[x - 1].addResult.get());
		// Setting the 8 input MUX result for each ALU
		for (int i = 0; i < x; i++) {
			alu[i].execute_pass2();
			result[i].set(alu[i].result.get());
		}
	}

}
