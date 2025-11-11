// * Author: Kory Smith

public class Sim2_AdderX {
	public RussWire[] a, b;
	public Sim2_FullAdder[] adders; // Array of full adders for each bit position
	private AND andGate;
	private XOR xorGate1, xorGate2;
	private NOT notGate;
	public RussWire[] sum;
	public RussWire carryOut, overflow;

	public Sim2_AdderX(int numBits) {
		a = new RussWire[numBits]; // Initialize arrays
		b = new RussWire[numBits];
		sum = new RussWire[numBits];
		adders = new Sim2_FullAdder[numBits];

		// Initialize gates
		andGate = new AND();
		xorGate1 = new XOR();
		xorGate2 = new XOR();
		notGate = new NOT();

		for (int i = 0; i < numBits; i++) { // Initialize wires and fullAdder
			a[i] = new RussWire();
			b[i] = new RussWire();
			sum[i] = new RussWire();
			adders[i] = new Sim2_FullAdder();
		}
		carryOut = new RussWire();
		overflow = new RussWire();
	}

	public void execute() {
		adders[0].carryIn.set(false); // Initialize carry = 0
		adders[0].a.set(a[0].get());
		adders[0].b.set(b[0].get());
		adders[0].execute();
		sum[0].set(adders[0].sum.get());

		for (int i = 1; i < adders.length; i++) { // Iterate through bits
			adders[i].a.set(a[i].get());
			adders[i].b.set(b[i].get());
			adders[i].carryIn.set(adders[i - 1].carryOut.get());
			adders[i].execute();
			sum[i].set(adders[i].sum.get());
		}

		// Check carry out
		carryOut.set(adders[adders.length - 1].carryOut.get());

		// Check overflow
		xorGate1.a.set(adders[adders.length - 1].a.get());
		xorGate1.b.set(adders[adders.length - 1].b.get());
		xorGate1.execute();

		notGate.in.set(xorGate1.out.get());
		notGate.execute();

		xorGate2.a.set(adders[adders.length - 1].sum.get());
		xorGate2.b.set(adders[adders.length - 1].a.get());
		xorGate2.execute();

		andGate.a.set(notGate.out.get());
		andGate.b.set(xorGate2.out.get());
		andGate.execute();

		overflow.set(andGate.out.get());
	}
}
