/* Simulates a physical device that performs 2's complement on a 32-bit input.
 *
 * Author: Kory Smith
 */

public class Sim1_2sComplement {
	public void execute() {
		// TODO: fill this in!
		//
		// REMEMBER: You may call execute() on sub-objects here, and
		// copy values around - but you MUST NOT create
		// objects while inside this function.

		// Reverse all of inputs and store in temp_out
		for (int i = 0; i < 32; i++) {
			not_in[i].in = in[i];
			not_in[i].execute();
			temp_out[i].set(not_in[i].out.get());
		}

		// Add 1 to temp_out and store as out
		add.a = temp_out;
		add.b = to_add;
		add.execute();
		out = add.sum;
	}

	// you shouldn't change these standard variables...
	public RussWire[] in;
	public RussWire[] out;

	// TODO: add some more variables here. You must create them
	// during the constructor below. REMEMBER: You're not
	// allowed to create any object inside the execute()
	// method above!

	private Sim1_NOT[] not_in;
	private Sim1_ADD add;

	private RussWire[] temp_out;
	private RussWire[] to_add;

	public Sim1_2sComplement() {
		// TODO: this is where you create the objects that
		// you declared up above.
		in = new RussWire[32];
		out = new RussWire[32];

		not_in = new Sim1_NOT[32];
		add = new Sim1_ADD();

		temp_out = new RussWire[32];
		to_add = new RussWire[32];

		for (int i = 0; i < 32; i++) {
			in[i] = new RussWire();
			out[i] = new RussWire();
			not_in[i] = new Sim1_NOT();

			temp_out[i] = new RussWire();
			to_add[i] = new RussWire();
		}

		// Set the to_add to a 1
		to_add[0].set(true);
		for (int i = 1; i < 32; i++) {
			to_add[i].set(false);
		}
	}
}
