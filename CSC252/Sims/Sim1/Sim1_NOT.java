/* Simulates a physical NOT gate.
 *
 * Author: Kory Smith
 */

public class Sim1_NOT
{
	public void execute()
	{
		out.set(!in.get());
	}

	public RussWire in;
	public RussWire out;

	public Sim1_NOT()
	{
		in = new RussWire();
		out = new RussWire();
	}
}

