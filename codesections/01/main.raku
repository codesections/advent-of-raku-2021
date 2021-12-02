use Test;

sub count-increases(@depth-list) {
    @depth-list.&{$_ Z< .skip}.sum
}
sub count-increases3(@depth-list) {
    [@depth-list.&{[Z+] $_, .skip, .skip(2) }].&{$_ Z< .skip}.sum
}

say count-increases 'input.txt'.IO.lines;
say count-increases3 'input.txt'.IO.lines;

count-increases(<199 200 208 210 200 207 240 269 260 263>).&is(7);
count-increases3(<199 200 208 210 200 207 240 269 260 263>).&is(5);
