// * Author: Kory Smith

public class Sim2_FullAdder {
	public RussWire a;
	public RussWire b;
	public RussWire carryIn;
	public RussWire sum;
	public RussWire carryOut;

	public Sim2_FullAdder() {
		a = new RussWire();
		b = new RussWire();
		carryIn = new RussWire();
		sum = new RussWire();
		carryOut = new RussWire();
	}

	public void execute() {
		// Initialize HalfAdders
		Sim2_HalfAdder ha1 = new Sim2_HalfAdder();
		Sim2_HalfAdder ha2 = new Sim2_HalfAdder();

		// Calculate first half with a, b
		ha1.a.set(a.get());
		ha1.b.set(b.get());
		ha1.execute();

		// Calculate second half using sum from first half and carryIn input
		ha2.a.set(ha1.sum.get());
		ha2.b.set(carryIn.get());
		ha2.execute();

		sum.set(ha2.sum.get()); // Sum = second half output

		// Check carryOut
		OR orGate = new OR();
		orGate.a.set(ha1.carry.get());
		orGate.b.set(ha2.carry.get());
		orGate.execute();
		carryOut.set(orGate.out.get());
	}
}
