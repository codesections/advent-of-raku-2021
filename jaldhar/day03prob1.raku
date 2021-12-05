#!/usr/bin/raku

sub MAIN() {
    my (%onebits, %zerobits);

    for './input/day03.input'.IO.lines -> $line {
        for 0 ..^ $line.chars -> $i {
            if $line.substr($i, 1) eq '1' {
                %onebits{$i}++;
            } else {
                %zerobits{$i}++;
            }
        }
    }

    my (@gamma, @epsilon);

    for 0 ..^ %onebits.elems -> $i {
        if %onebits{$i} > %zerobits{$i} {
            @gamma[$i] = 1;
            @epsilon[$i] = 0;
        } else {
            @gamma[$i] = 0;
            @epsilon[$i] = 1;
        }
    }

    say @gamma.join.parse-base(2) * @epsilon.join.parse-base(2);
}
