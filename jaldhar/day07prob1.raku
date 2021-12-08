#!/usr/bin/raku

sub MAIN() {
    my $line =  './input/day07.input'.IO.lines;
    my @crabs = $line.split(/\,/);
    
    my $bestEnergy = Inf;

    for 0 ..^ @crabs.elems -> $i {
        my $energy =  [+] @crabs.map({ ($_ - $i).abs; });
        if $energy < $bestEnergy {
            $bestEnergy = $energy;
        }
    }

    say $bestEnergy;
}
