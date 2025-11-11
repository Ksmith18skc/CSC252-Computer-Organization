// * Author: Kory Smith

public class Sim2_HalfAdder {
	public RussWire a;
	public RussWire b;
	public RussWire sum;
	public RussWire carry;

	public Sim2_HalfAdder() {
		a = new RussWire();
		b = new RussWire();
		sum = new RussWire();
		carry = new RussWire();
	}

	public void execute() {
		// Initialize gates
		XOR xorGate = new XOR();
		AND andGate = new AND();

		// Set XOR inputs
		xorGate.a.set(a.get());
		xorGate.b.set(b.get());

		xorGate.execute();

		sum.set(xorGate.out.get()); // Sum = XOR gate output

		// Set AND inputs
		andGate.a.set(a.get());
		andGate.b.set(b.get());

		andGate.execute();

		carry.set(andGate.out.get()); // Carry = AND gate output
	}
}
