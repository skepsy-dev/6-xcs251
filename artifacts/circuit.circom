
template Multiplier() {
     signal input a;
     signal input b;
     signal input c;
     signal input d;
     signal output z;
     
     d <== a*b;

     z <== d*c;

}

component main = Multiplier();