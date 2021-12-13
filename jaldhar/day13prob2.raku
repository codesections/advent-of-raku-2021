#!/usr/bin/raku

sub display(%dotlist) {
    my @dots = %dotlist.keys.map({ $_.split(/'-'/); });
    my $width = @dots.sort({ $^b[0] <=> $^a[0] })[0][0];
    my $height = @dots.sort({ $^b[1] <=> $^a[1] })[0][1];

    for 0 .. $height -> $row {
        for 0 .. $width -> $col {
            print %dotlist{"$col-$row"}:exists ?? '*' !! ' ';
        }
        print "\n";
    }
}

sub foldleft(%dotlist, $divider) {
    my %newdotlist;
    my @dots = %dotlist.keys.map({ $_.split(/'-'/; )});
    for @dots -> $dot {
        my ($col, $row) = $dot;
        if $col > $divider {
            my $newcol = $divider - ($col - $divider);
            %newdotlist{"$newcol-$row"} = True;
        } else {
            %newdotlist{"$col-$row"} = True;
        }
    }

    return %newdotlist
}

sub foldup(%dotlist, $divider) {
    my %newdotlist;
    my @dots = %dotlist.keys.map({ $_.split(/'-'/; )});
    for @dots -> $dot {
        my ($col, $row) = $dot;
        if $row > $divider {
            my $newrow = $divider - ($row - $divider);
            %newdotlist{"$col-$newrow"} = True;
        } else {
            %newdotlist{"$col-$row"} = True;
        }
    }

    return %newdotlist
}

sub MAIN() {
    my $isDotList = True;
    my %dotlist;
    my @foldlist;

    for './input/day13.input'.IO.lines -> $line {
        if $line eq q{} {
            $isDotList = False;
            next;
        }
        if $isDotList {
            my ($col, $row) = $line.split(/','/);
            %dotlist{"$col-$row"} = True;
        } else {
            my ($dir, $lineno) = $line.match(/(.)'='(\d+)/).List;
            @foldlist.push([$dir, $lineno]);
        }
    }

    for 0 ..^ @foldlist.elems -> $i {
        given @foldlist[$i][0] {
            when 'y' {
                %dotlist = foldup(%dotlist, @foldlist[$i][1]);
            }
            when 'x' {
                %dotlist = foldleft(%dotlist, @foldlist[$i][1]);
            }
            default {}
        }
    }

    display(%dotlist);
}
