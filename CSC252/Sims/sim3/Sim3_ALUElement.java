// * Author: Kory Smith

public class Sim3_ALUElement {

	// Inputs
	public RussWire[] aluOp; // Array to hold the ALU operation control bits
	public RussWire bInvert; // Control bit to invert input b
	public RussWire a; // Input a
	public RussWire b; // Input b
	public RussWire carryIn; // Carry input
	public RussWire less; // Less-than comparison output

	// Outputs
	public RussWire result; // ALU result
	public RussWire addResult; // Addition result
	public RussWire carryOut; // Carry output

	// Components
	public Sim3_MUX_8by1 mux2; // 2-to-1 MUX
	public Sim3_MUX_8by1 mux8; // 8-to-1 MUX
	public OR orGate; // OR gate
	public XOR xorGate; // XOR gate
	public AND andGate; // AND gate
	public Sim2_FullAdder adder; // Full adder

	// Constructor
	public Sim3_ALUElement() {
		// Initialize input wires
		aluOp = new RussWire[3];
		for (int i = 0; i < 3; i++) {
			aluOp[i] = new RussWire();
		}

		bInvert = new RussWire();
		a = new RussWire();
		b = new RussWire();
		carryIn = new RussWire();
		less = new RussWire();

		// Initialize output wires
		result = new RussWire();
		addResult = new RussWire();
		carryOut = new RussWire();

		// Initialize components
		mux8 = new Sim3_MUX_8by1();
		mux2 = new Sim3_MUX_8by1();
		andGate = new AND();
		orGate = new OR();
		adder = new Sim2_FullAdder();
		xorGate = new XOR();
	}

	// Executing the first pass through the ALU
	public void execute_pass1() {
		// Setting inputs and control bits for the 2-to-1 MUX
		mux2.in[0].set(b.get());
		mux2.in[1].set(!b.get());
		mux2.control[0].set(bInvert.get());
		mux2.execute2Inputs();

		// AND gate operation
		andGate.a.set(a.get());
		andGate.b.set(mux2.out.get());
		andGate.execute();
		// OR gate operation
		orGate.a.set(a.get());
		orGate.b.set(mux2.out.get());
		orGate.execute();

		// Full adder operation
		adder.a.set(a.get());
		adder.b.set(mux2.out.get());
		adder.carryIn.set(carryIn.get());
		adder.execute();

		// Setting output wires
		addResult.set(adder.sum.get());
		carryOut.set(adder.carryOut.get());
		// XOR gate operation
		xorGate.a.set(a.get());
		xorGate.b.set(mux2.out.get());
		xorGate.execute();
	}

	// Executing the second pass through the ALU
	public void execute_pass2() {
		// Creating an array of input wires
		RussWire[] inputs = { andGate.out, orGate.out, adder.sum, less, xorGate.out };
		// Setting inputs for the 8-to-1 MUX

		for (int i = 0; i < 5; i++) {
			mux8.in[i].set(inputs[i].get());
		}

		// Setting remaining inputs to false
		for (int i = 5; i < 8; i++) {
			mux8.in[i].set(false);
		}

		// Setting control bits for the 8-to-1 MUX
		for (int i = 0; i < 3; i++) {
			mux8.control[i].set(aluOp[i].get());
		}

		// Executing the 8-to-1 MUX and setting the result
		mux8.execute();
		result.set(mux8.out.get());
	}

}