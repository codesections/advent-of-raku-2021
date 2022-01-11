#!/usr/bin/raku

sub MAIN() {
    my @cavern = './input/day11.input'.IO.lines.map({ [$_.comb]; });
    my @nextcavern = @cavern;
    my @dirs = ([0, -1], [-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1]);
    my $flashes = 0;
 
    my $inbounds = sub (Int $row, Int $col) {
        return $row >= 0 && $row < @cavern.elems && $col >= 0 &&
            $col < @cavern[$row].elems;
    }

    my $flash = sub (Int $row, Int $col) {
        $flashes++;
        @cavern[$row][$col] = 0;

        for @dirs.map({ [$row + $_[0], $col + $_[1]] }) -> $a {
            if $inbounds($a[0], $a[1]) {
                if @cavern[$a[0]][$a[1]] > 0 && @cavern[$a[0]][$a[1]] < 10 { 
                    @cavern[$a[0]][$a[1]]++;
                    if @cavern[$a[0]][$a[1]] > 9 {
                        $flash($a[0], $a[1]);
                    }
                }
            }
        }
    }

    for 0 ..^ 100 {
        for 0 ..^ @cavern.elems -> $row {
            for 0 ..^ @cavern[$row].elems -> $col {
                @cavern[$row][$col]++;
            }
        }

        for 0 ..^ @cavern.elems -> $row {
            for 0 ..^ @cavern[$row].elems -> $col {
                if @cavern[$row][$col] > 9 {
                    $flash($row, $col);
                }
            }
        }
     }

    say $flashes;
}
