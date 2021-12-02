use Test;

sub count-increases(@depth-list) {
    @depth-list.&{$_ Z< .skip}.sum
}
sub count-increases3(@depth-list) {
    @depth-list.&{$_ Z+ .skip Z+ .skip(2)}.cache.&{$_ Z< .skip}.sum
}

say count-increases 'input.txt'.IO.lines;
say count-increases3 'input.txt'.IO.lines;
my @sample = <199 200 208 210 200 207 240 269 260 263>;
put +@sample.&{$_ Z .skip}.map(-> ($a, $b) { $a < $b }).grep(*.so);
say @sample.&{$_ Z .skip}.flat.map({ $^a < $^b }).sum;
say @sample.&{$_ Z .skip}.flat.map(* < *).sum;
say @sample.&{$_ Z< .skip}.sum;
say @sample.&{$_ Z< .skip};
say  @sample.&{$_ Z< .skip};

say [+] @sample.&{$_ Z< .skip};
count-increases(<199 200 208 210 200 207 240 269 260 263>).&is(7);
count-increases3(<199 200 208 210 200 207 240 269 260 263>).&is(5);
