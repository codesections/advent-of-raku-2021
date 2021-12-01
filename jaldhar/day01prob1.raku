#!/usr/bin/raku

sub MAIN() {
    my  $previous = Inf;
    my $greater = 0;

    for './input/day01.input'.IO.lines -> $line {
        my $current = $line.Int;
        if $current > $previous {
            $greater++;
        }
        $previous = $current;
    }

    say $greater;
}