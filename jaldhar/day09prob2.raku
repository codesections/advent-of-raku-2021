#!/usr/bin/raku

sub MAIN() {
    my @heightmap =  './input/day09.input'.IO.lines.map({ $_.comb; });
    my @basins;
    my @dirs = ([0, -1], [-1, 0], [0, 1], [1, 0]);
 
    my $inbounds = sub (Int $row, Int $col) {
        return $row >= 0 && $row < @heightmap.elems && $col >= 0 &&
            $col < @heightmap[$row].elems;
    }

    my $findBasin = sub ($row, $col) {
        my @q;
        @q.push([$row, $col]);
        my $count = 1;
        my %visited;

        while @q.elems {
            my ($r, $c) = @q.shift;
            for @dirs.map({ [$r + $_[0], $c + $_[1]] }) -> $a {
                if $inbounds($a[0], $a[1]) &&
                (%visited{"$a[0]$a[1]"}:!exists) &&
                @heightmap[$a[0]][$a[1]] != 9 &&
                @heightmap[$a[0]][$a[1]] >= @heightmap[$r][$c] {
                    %visited{"$a[0]$a[1]"} = True;
                    @q.push($a);
                    $count++;
                }
            }
        }
        return $count;
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
                @basins.push($findBasin($row, $col));
            }
        }
    }

    say [*] @basins.sort({ $^b <=> $^a})[0 .. 2];
}
