# Palindrome-Checker-in-verilog
A robust palindrome checker hardware implementation in Verilog, which checks for Palindrome of variable sizes.

A gives the input sequence serially, B is the size of palindrome to be checked, D_out is high when a palindrome is detected and C_out gives the palindrome as output. The done_sig becomes high when all the serial inputs are done.

Here you can see "12321" being detected by the D_out getting high after 5 serial inputs

<img width="2134" height="916" alt="image" src="https://github.com/user-attachments/assets/5aaf6a12-6490-444d-bfcd-813b3bc133f4" />

Here you can see "12345" Being given as input and D_out still being low, and C_out giving "0000000", as it's not a palindrome

<img width="1987" height="480" alt="image" src="https://github.com/user-attachments/assets/e57d1f3c-a832-4874-9e9e-4dddc5fc4fe8" />

The detector also detects characters, here B=4, so it detects a 4 bit "abba" as a palindome

<img width="2097" height="509" alt="image" src="https://github.com/user-attachments/assets/fb3bd490-029e-40d0-ae0a-1100a0e342f2" />


