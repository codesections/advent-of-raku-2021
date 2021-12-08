#!/usr/bin/raku

sub MAIN() {
    my $line =  './input/day06.input'.IO.lines[0];
    my @lanternfish = $line.split(/\,/);

    for 0 ..^ 80 {
        my $babies = 0;

        for 0 ..^ @lanternfish.elems -> $i {
            if @lanternfish[$i] == 0 {
                @lanternfish[$i] = 6;
                $babies++;
            } else {
                @lanternfish[$i] -= 1;
            }
        }

        @lanternfish.append(8 xx $babies);
    }

    say @lanternfish.elems;
}