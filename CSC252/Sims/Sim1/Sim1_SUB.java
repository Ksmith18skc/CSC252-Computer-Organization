/* Simulates a physical device that performs (signed) subtraction on
 * a 32-bit input.
 *
 * Author: Kory Smith
 */

public class Sim1_SUB
{
	public void execute()
	{
		// TODO: fill this in!
		//
		// REMEMBER: You may call execute() on sub-objects here, and
		//           copy values around - but you MUST NOT create
		//           objects while inside this function.
        
        // Get the 2sComplement of b and store in toAdd
        complement.in = b;
        complement.execute();
        toAdd = complement.out;
        
        // Add a and 2sComplement of b and store it to sum
        add.a = a;
        add.b = toAdd;
        add.execute();
        sum = add.sum;
        
        // Get the overflow from add
        overflow = add.overflow;
	}



	// --------------------
	// Don't change the following standard variables...
	// --------------------

	// inputs
	public RussWire[] a,b;

	// output
	public RussWire[] sum;

	// --------------------
	// But you should add some *MORE* variables here.
	public RussWire overflow;

	// --------------------
	// TODO: fill this in
	 private Sim1_2sComplement complement;
	 private RussWire[] toAdd;
	 private Sim1_ADD add;



	public Sim1_SUB()
	{
		// TODO: fill this in!
        a   = new RussWire[32];
        b   = new RussWire[32];
        sum = new RussWire[32];
  
        overflow = new RussWire();
        complement = new Sim1_2sComplement();
        toAdd = new RussWire[32];
        add = new Sim1_ADD();
        
        for (int i=0; i<32; i++)
        {
            toAdd[i] = new RussWire();
            a  [i] = new RussWire();
            b  [i] = new RussWire();
            sum[i] = new RussWire();
        }
	}
}

