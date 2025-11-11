/* Simulates a physical AND gate.
 *
 * Author: Kory Smith
 */

public class Sim1_AND
{
	public void execute()
	{
		this.out.set(a.get() && b.get());
	}
	
	public RussWire a,b;   // inputs
	public RussWire out;   // output

	public Sim1_AND()
	{
		a   = new RussWire();
		b   = new RussWire();
		out = new RussWire();
	}
}

