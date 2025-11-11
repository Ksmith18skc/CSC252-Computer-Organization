// /* Implementation of a 32-bit adder in C.
//  *
//  * author: Kory Smith
//  */

#include "sim1.h"

void execute_add(Sim1Data *obj)
{
    int i;
    int carry = 0;
    obj->overflow = 0;
    int significanta = ((obj->a >> 31) & 0x1);
    int significantB = ((obj->b >> 31) & 0x1);
    if (significanta == 0)
    {
        obj->aNonNeg = 1;
    }
    else
    {
        obj->aNonNeg = 0;
    }

    if (significantB == 0)
    {
        obj->bNonNeg = 1;
    }
    else
    {
        obj->bNonNeg = 0;
    }
    if (obj->isSubtraction == 1)
    {
        carry = 1;
    }

    for (i = 0; i < 32; i++)
    {
        int aBit = (obj->a >> i) & 0x1;
        int bBit = (obj->b >> i) & 0x1;
        if (obj->isSubtraction == 1)
        {
            bBit = bBit ^ 1;
        }
        int result = (aBit ^ bBit) ^ carry;
        carry = ((aBit & bBit) | (carry & aBit) ^ (carry & bBit));
        if (result == 1)
        {
            obj->sum = (0x1 << i) | obj->sum;
        }
    }

    int significantSum = ((obj->sum >> 31) & 0x1);
    obj->sumNonNeg = (significantSum == 0) ? 1 : 0;

    int signs = significanta & significantB;
    if ((signs & significantSum) != signs)
    {
        obj->overflow = 1;
    }


    obj->carryOut = carry;
}


