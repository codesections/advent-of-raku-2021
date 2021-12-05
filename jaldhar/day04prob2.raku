#!/usr/bin/raku

sub unmarkedSum(@board) {
    return [+] @board[*;*].grep({ $_ < 100; });
}

sub isBingo(@board) {
    my (@leftDiag, @rightDiag);
    my $end = @board.elems - 1;

    for 0 ..^ @board.elems -> $i {
        if @board[$i;*].all > 100 {
            return True;
        }

        if @board[*;$i].all > 100 {
            return True;
        }

        @leftDiag.push(@board[$i;$i]);
        @rightDiag.push(@board[$i;$end - $i]);
    }

    if @leftDiag.all > 100 {
        return True;
    }

    if @rightDiag.all > 100 {
        return True;
    }

    return False;
}

sub makeBoard(Str $content) {
    my @board;

    for $content.split(/\n/) -> $row {
        my @cols = $row.split(/\s+/);
        @board.push(@cols);
    }

    return @board;
}

sub search(@board, $n) {
    for 0 ..^ @board.elems -> $i {
        for 0 ..^ @board[$i].elems -> $j {
            if (@board[$i][$j] == $n) {
                @board[$i][$j] += 100;
            }
        }
    }

    return isBingo(@board);
}

sub MAIN() {
    my (@oxygen, @co2);

    my @boards =  './input/day04.input'.IO.slurp.split(/\n\n/);
    my @order = @boards.shift.split(/\,/);

    for 0 ..^ @boards.elems -> $i {
        @boards[$i] = makeBoard(@boards[$i]);
    }

    my @winningBoards;
    my @winningSums;

    for @order -> $n {
        for 0 ..^ @boards.elems -> $i {
            if @winningBoards.any == $i {
                next;
            }

            if search(@boards[$i], $n) {
                @winningBoards.push($i);
                @winningSums.push(unmarkedSum(@boards[$i]) * $n);
            }
        }
    }

    say @winningSums[*-1];
}
