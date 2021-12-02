#!/usr/bin/raku

sub MAIN() {
    my $position = 0;
    my $depth = 0;
    my $aim = 0;

    for './input/day02.input'.IO.lines -> $line {
        my ($direction, $unit) = $line.split(q{ });

        given $direction {
            when 'up'      -> { $aim -= $unit; }
            when 'down'    -> { $aim += $unit; }
            when 'forward' -> {
                                $position += $unit;
                                $depth += ($aim * $unit);
                              }
        }
    }

    say $position * $depth;
}
