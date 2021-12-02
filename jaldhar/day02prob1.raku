#!/usr/bin/raku

sub MAIN() {
    my $position = 0;
    my $depth = 0;

    for './input/day02.input'.IO.lines -> $line {
        my ($direction, $unit) = $line.split(q{ });

        given $direction {
            when 'up'      -> { $depth -= $unit; }
            when 'down'    -> { $depth += $unit; }
            when 'forward' -> { $position += $unit; }
        }
    }

    say $position * $depth;
}