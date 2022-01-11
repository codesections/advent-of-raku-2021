#!/usr/bin/raku

sub MAIN() {
    my @incompletes;
    my %delimeters =(
        '(' => ')',
        '[' => ']',
        '{' => '}',
        '<' => '>'
    );

    for './input/day10.input'.IO.lines -> $line {
        my @stack;
        my $corrupted = False;
        my @characters = $line.comb;
        for @characters -> $c {
            given $c {
                when '(' {
                    @stack.push('(');
                }
                when '[' {
                    @stack.push('[');
                }
                when '{' {
                    @stack.push('{');
                }
                when '<' {
                    @stack.push('<');
                }
                when ')' {
                    if @stack[*-1] eq '(' {
                        @stack.pop;
                    } else {
                        $corrupted = True;
                        last;
                    }
                }
                when ']' {
                    if @stack[*-1] eq '[' {
                        @stack.pop;
                    } else {
                        $corrupted = True;
                        last;
                    }
                }
                when '}' {
                    if @stack[*-1] eq '{' {
                        @stack.pop;
                    } else {
                        $corrupted = True;
                        last;
                    }
                }
                when '>' {
                    if @stack[*-1] eq '<' {
                        @stack.pop;
                    } else {
                        $corrupted = True;
                        last;
                    }
                }
            }
        }
        if !$corrupted && @stack.elems {
            @incompletes.push(@stack.map({ %delimeters{$_}; }).reverse);
        }
    }

    my %points = (
        ')' => 1,
        ']' => 2,
        '}' => 3,
        '>' => 4,
    );

    my @scores;
    my $scale = 5;

    for @incompletes -> @incomplete {
        my $score = 0;
        for @incomplete -> $elem {
            $score *= $scale;
            $score += %points{$elem};
        }
        @scores.push($score);
    }

    say @scores.sort({ $^a <=> $^b })[@scores.elems div 2];
}
