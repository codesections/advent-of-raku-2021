#!/usr/bin/raku

constant $gravity = 1;

sub attempt($xVelocity is copy, $yVelocity is copy, $x, $y) {
    my $xPos = 0;
    my $yPos = 0;
    my $maxY = -∞;
    my ($xStart, $xEnd) = $x.minmax;
    my ($yStart, $yEnd) = $y.minmax;

    loop {
        if $xStart <= $xPos <= $xEnd && $yStart <= $yPos <= $yEnd {
            return $maxY;
        }

        if $xPos > $xEnd || $yPos < $yStart {
            return Nil; 
        }

        $xPos += $xVelocity;
        $yPos += $yVelocity;
        $yVelocity -= $gravity;

        if $xVelocity > 0 {
            $xVelocity--;
        } elsif $xVelocity < 0 {
            $xVelocity++;
        }

        if $yPos > $maxY {
            $maxY = $yPos;
        }
    }
}

sub MAIN() {
    my $line =  './input/day17.input'.IO.lines;
    my @bounds =
        $line.match(/ .+? ('-'?\d+) .+? ('-'?\d+) .+? ('-'?\d+) .+? ('-'?\d+)/)
            .List
            .map({ $_.Int; });
    my $x = @bounds[0] .. @bounds[1];
    my $y = @bounds[2] .. @bounds[3];

    my @heights;

    for 1 .. $x.max -> $i {
        for 1 ..^ $y.min.abs -> $j {
            @heights.push(attempt($i, $j, $x, $y));
        }
    }

    say @heights.max;
}
