template Multiplier() {
     signal input a;
     signal input b;
     signal input c;
     signal output z;
     
     var d = a*b;

     z <== d*c;
}

component main = Multiplier();