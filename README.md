# Integer-to-ASCII-String-Assembly
Converts an integer in hex, dec, or bin to equivalent ASCII string with hex values 
October 2018
Function: int_to_ascii

This functions purpose is to convert an integer value, in hex, dec, or binary to it's ascii equivalent.
	For example: 34 = 20 33 34
	with the 20 being a space at the start to indicate positive and 33 and 34 being hex ascii values for 3 and 4 respectively

The function takes the input number:
	Divides the number by 10 (this gives the value initially in the 1's spot)
	Multiplies the number by 10
	Takes the original number unaffected by multiplication and subtracts the value multiplied by 10 to get remainder
	Remainder is an individual value 0-9 
	converted to ascii by adding 0x30

ex: 
34 / 10 = 3
3 * 10 = 30
34 - 30 = 4 = remainder
4 + 0x30 = 34 = ascii value

Number to convert to ascii is loaded with LDR into R9 at line 31
Memory buffer is stored in R10 at 0x20000030
