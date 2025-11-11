/* Simulates a physical device that performs (signed) addition on
 * a 32-bit input.
 *
 * Author: Kory Smith
 */

public class Sim1_ADD
{
	public void execute()
	{
		// TODO: fill this in!
		boolean liveA;
		boolean liveB;
		boolean carry = false;
			
		for(int i = 0; i < 32; i++) {
			liveA = this.a[i].get();
			liveB = this.b[i].get();

			if (liveA == false && liveB == false && carry == false)
			{
				this.sum[i].set(false);
				carry = false;
			}
			else if (liveA == false && liveB == false && carry == true)
			{
				this.sum[i].set(true);
				carry = false;
			}
			else if (liveA == true && liveB == false && carry == false )
			{
				this.sum[i].set(true);
				carry = false;
			}
			else if(liveA == false && liveB == true && carry == false)
			{
				this.sum[i].set(true);
				carry = false;
			}
			else if(liveA == true && liveB == true && carry == false)
			{
				this.sum[i].set(false);
				carry = true;
			}
			else if(liveA == true && liveB == false && carry == true)
			{
				this.sum[i].set(false);
				carry = true;
			}
			else if(liveA == false && liveB == true && carry == true) 
			{
				this.sum[i].set(false);
				carry = true;
			}
			else if(liveA == true && liveB == true && carry == true)
			{
				this.sum[i].set(true);
				carry = true;
			}
		}
		
		//carry-out scan
		if(carry) {
			carryOut.set(true);
		} else {
			carryOut.set(false);
		}
		
		// overflow scan
		if((a[31].get() != b[31].get()) && !carry) {
			overflow.set(false);
		} else {
			if(a[31].get() == true && b[31].get() == true && sum[31].get() == true && !carry) {
				overflow.set(true);
			} else if(a[31].get() == false && b[31].get() == false && sum[31].get() == true && !carry) {
				overflow.set(true);
			} else if(a[31].get() == true && b[31].get() == true && sum[31].get() == false && carry) {
				overflow.set(true);
			} else if(a[31].get() == false && b[31].get() == false && sum[31].get() == false && carry) {
				overflow.set(true);
			} else {
				overflow.set(false);
			}
		}
	}



	// ------ 
	// It should not be necessary to change anything below this line,
	// although I'm not making a formal requirement that you cannot.
	// ------ 

	// inputs
	public RussWire[] a,b;

	// outputs
	public RussWire[] sum;
	public RussWire   carryOut, overflow;

	public Sim1_ADD()
	{
		/* Instructor's Note:
		 *
		 * In Java, to allocate an array of objects, you need two
		 * steps: you first allocate the array (which is full of null
		 * references), and then a loop which allocates a whole bunch
		 * of individual objects (one at a time), and stores those
		 * objects into the slots of the array.
		 */

		a   = new RussWire[32];
		b   = new RussWire[32];
		sum = new RussWire[32];

		for (int i=0; i<32; i++)
		{
			a  [i] = new RussWire();
			b  [i] = new RussWire();
			sum[i] = new RussWire();
		}

		carryOut = new RussWire();
		overflow = new RussWire();
	}
}

