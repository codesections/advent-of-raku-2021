#!/usr/bin/raku

sub MAIN() {
    my $count = 0;

    for './input/day08.input'.IO.lines -> $line {
        my @fields = $line.split(/\s+/);
        my @signals = @fields.splice(0, 10);
        my @output = @fields.splice(1, 4);

        for @output -> $digit {
            if (2, 3, 4, 7).any == $digit.chars {
                $count++;
            }
        }
    }
    
    say $count;
}
