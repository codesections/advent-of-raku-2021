#!/usr/bin/raku

sub MAIN() {
    my $error = 0;

    for './input/day10.input'.IO.lines -> $line {
        my @stack;
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
                        $error += 3;
                        last;
                    }
                }
                when ']' {
                    if @stack[*-1] eq '[' {
                        @stack.pop;
                    } else {
                        $error += 57;
                        last;
                    }
                }
                when '}' {
                    if @stack[*-1] eq '{' {
                        @stack.pop;
                    } else {
                        $error += 1197;
                        last;
                    }
                }
                when '>' {
                    if @stack[*-1] eq '<' {
                        @stack.pop;
                    } else {
                        $error += 25137;
                        last;
                    }
                }
            }
        }
    }

    say $error;
}
