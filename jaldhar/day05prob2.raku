#!/usr/bin/raku

sub MAIN() {
    my %board;

    for './input/day05.input'.IO.lines -> $line {
        my ($x1, $y1, $x2, $y2) =
            $line.match(/ (\d+)','(\d+)' -> '(\d+)','(\d+) / )
                .values
                .map({ $_.Int; });

        if $x1 == $x2 {
            my ($start, $end) = $y1 < $y2 ?? ($y1, $y2) !! ($y2, $y1);

            for $start .. $end -> $y {
                %board{"$x1-$y"}++;
            }
        }

        if $y1 == $y2 {
            my ($start, $end) = $x1 < $x2 ?? ($x1, $x2) !! ($x2, $x1);

            for $start .. $end -> $x {
                %board{"$x-$y1"}++;
            }
        }

        if ($x1 - $x2).abs == ($y1 - $y2).abs {
            my ($start, $end, $op, $y);

            if $x1 < $x2 {
                $start = $x1;
                $end = $x2;
                $op = $y1 < $y2 ?? -> $y is rw {$y++;} !! -> $y is rw {$y--;}
                $y = $y1;
            } else {
                $start = $x2;
                $end = $x1;
                $op = $y1 < $y2 ?? -> $y is rw {$y--;} !! -> $y is rw {$y++;}
                $y = $y2;
            }

            for $start .. $end -> $x {
                %board{"$x-$y"}++;
                $op($y);
            }
        }
    }

    %board.values.grep({ $_ > 1; }).elems.say;
}
