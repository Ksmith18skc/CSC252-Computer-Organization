// * Author: Kory Smith

//This class models a 8-input MUX, where each input is a single bit wide. Since
//it has 8 inputs, there are 3 control bits. (As with our adders, treat element 0 of
//the control array as the LSB of the control input.)

public class Sim3_MUX_8by1 {

	public RussWire[] control; // Array to hold the control bits
	public RussWire[] andGates; // Array to hold the AND gate outputs
	public RussWire[] in; // Array to hold the inputs
	public RussWire out; // Output wire

	public Sim3_MUX_8by1() {
		control = new RussWire[3]; // Initialize the control array with 3 elements
		in = new RussWire[8]; // Initialize the input array with 8 elements
		out = new RussWire(); // Initialize the output wire
		andGates = new RussWire[8]; // Initialize the AND gate output array with 8 elements

		// Initialize each element in the control array
		for (int i = 0; i < 3; i++) {
			control[i] = new RussWire();
		}

		// Initialize each element in the input array

		for (int i = 0; i < 8; i++) {
			in[i] = new RussWire();
			andGates[i] = new RussWire();
		}
	}
	// Execute MUX operation

	public void execute() {
		// Calculate the index based on the control bits
		int index = (control[2].get() ? 1 : 0) << 2 | (control[1].get() ? 1 : 0) << 1 | (control[0].get() ? 1 : 0);

		// Set the output to the selected input
		out.set(in[index].get());
	}

	// Method to execute the MUX operation with 2 inputs

	public void execute2Inputs() {
		// Calculate the AND gate outputs

		andGates[0].set(in[0].get() & !control[0].get());
		andGates[1].set(in[1].get() & control[0].get());
		// Set the output to the OR of the AND gate outputs

		out.set(andGates[0].get() | andGates[1].get());
	}
}