Name: []

## Question 1

In the following code-snippet from `Num2Bits`, it looks like `sum_of_bits`
might be a sum of products of signals, making the subsequent constraint not
rank-1. Explain why `sum_of_bits` is actually a _linear combination_ of
signals.

```
        sum_of_bits += (2 ** i) * bits[i];
```

## Answer 1
This product of signals is actually processed as a linear expression because the combination can also be written using multiplication of variables by constants. For example the expression (2 ** i) is allowed, which is equivalent to 2^2 + 2^2 i times. 

## Question 2

Explain, in your own words, the meaning of the `<==` operator.

## Answer 2
<== is and assignment operator establishing the left hand element 
as equal to or now being a constrait of the variable or formula to 
the right of the operator. 

## Question 3

Suppose you're reading a `circom` program and you see the following:

```
    signal input a;
    signal input b;
    signal input c;
    (a & 1) * b === c;
```

Explain why this is invalid.

## Answer 3
The & operator is not valid in use of a non quadratic constraint.
