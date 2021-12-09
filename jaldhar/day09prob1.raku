#!/usr/bin/raku

sub MAIN() {
    my @heightmap =  './input/day09.input'.IO.lines.map({ $_.comb; });
    my @risklevels;
    my @dirs = ([0, -1], [-1, 0], [0, 1], [1, 0]);
 
    my $inbounds = sub (Int $row, Int $col) {
        return $row >= 0 && $row < @heightmap.elems && $col >= 0 &&
            $col < @heightmap[$row].elems;
    }

    for 0 ..^ @heightmap.elems -> $row {
        for 0 ..^ @heightmap[$row].elems -> $col {
            my @adjacencies;
            for @dirs.map({ [$row + $_[0], $col + $_[1]] }) -> $adjacent {
                if $inbounds($adjacent[0], $adjacent[1]) {
                     @adjacencies.push(@heightmap[$adjacent[0]][$adjacent[1]]);
                }
            }
            if @adjacencies.all > @heightmap[$row][$col] {
                @risklevels.push(@heightmap[$row][$col] + 1);
            }
        }
    }

    say [+] @risklevels;
}
