#!/usr/bin/raku

sub MAIN() {
    my (@oxygen, @co2);

    for './input/day03.input'.IO.lines -> $line {
        @oxygen.push($line);
        @co2.push($line);
    }

    for 0 ..^ @oxygen[0].chars -> $i {
        my (%onebits, %zerobits);
    
        for @oxygen -> $number {
            for 0 ..^ $number.chars -> $j {
                if $number.substr($j, 1) eq '1' {
                    %onebits{$j}++;
                } else {
                    %zerobits{$j}++;
                }
            }
        }

        if %onebits{$i} >= %zerobits{$i} {
            @oxygen = @oxygen.grep({ $_.substr($i, 1) ne '1'; });
        } else {
            @oxygen = @oxygen.grep({ $_.substr($i, 1) ne '0'; });
        }

        if (@oxygen.elems == 1) {
            last;
        }
    }

    for 0 ..^ @co2[0].chars -> $i {
        my (%onebits, %zerobits);

        for @co2 -> $number {
            for 0 ..^ $number.chars -> $j {
                if $number.substr($j, 1) eq '1' {
                    %onebits{$j}++;
                } else {
                    %zerobits{$j}++;
                }
            }
        }

        if %zerobits{$i} <= %onebits{$i} {
            @co2 = @co2.grep({ $_.substr($i, 1) ne '0'; });
        } else {
            @co2 = @co2.grep({ $_.substr($i, 1) ne '1'; });
        }

        if (@co2.elems == 1) {
            last;
        }
    }

    say @oxygen[0].parse-base(2) * @co2[0].parse-base(2);
}