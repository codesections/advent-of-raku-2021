#!/usr/bin/raku

sub MAIN() {
    my $previous = Inf;
    my $count = 0;
    my $greater = 0;
    my @window;

    for './input/day01.input'.IO.lines -> $line {
        @window[$count % 3] = $line.Int;
        if ($count > 1) {
            my $current = [+] @window;
            if ($current > $previous) {
                $greater++;
            }
            $previous = $current;
        }
        $count++;
    }

    say $greater;
}