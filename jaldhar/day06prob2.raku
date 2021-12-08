#!/usr/bin/raku

sub MAIN() {
    my $line =  './input/day06.input'.IO.lines[0];
    my @lanternfish = $line.split(/\,/);

    my %ttl;
    for @lanternfish -> $fish {
        %ttl{$fish}++
    }

    for 0 ..^ 256 {
        my $spawning = %ttl{0};
        %ttl{0} = 0;

        for 1 .. 8 -> $i {
            %ttl{$i - 1} = %ttl{$i}; 
        }

        if $spawning {
            %ttl{6} += $spawning;
        }

        %ttl{8} = $spawning;
    }

    say [+] %ttl.values;
}