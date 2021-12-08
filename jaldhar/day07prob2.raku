#!/usr/bin/raku

sub MAIN() {
    my $line =  './input/day07.input'.IO.lines;
    my @crabs = $line.split(/\,/);
    
    my $bestEnergy = Inf;

    for 0 ..^ @crabs.elems -> $i {
        my $energy =
            [+] @crabs.map({ my $n = ($_ - $i).abs; ($n / 2) * ($n + 1) });
        if $energy < $bestEnergy {
            $bestEnergy = $energy;
        }
    }

    say $bestEnergy;
}