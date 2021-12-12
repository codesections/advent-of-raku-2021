#!/usr/bin/raku

sub visit($dest, $count is rw, %graph, %visited is copy,  Bool $bonusvisit is copy, @path is copy) {
    @path.push($dest);
    if $dest eq 'end' {
        $count++;
        return;
    }

    %visited{$dest}++;
    if $dest.match(/^ <:Ll>+ $/).so && %visited{$dest} == 2 {
        $bonusvisit = False;
    }

    for %graph{$dest} -> @children {
        for @children -> $next {
            if $next.match(/^ <:Ll>+ $/).so {
                if ($next eq 'start' || !$bonusvisit) && %visited{$next} > 0 {
                    next;
                }
                if $bonusvisit && %visited{$next} > 1 {
                    next;
                }
            }
            visit($next, $count, %graph, %visited, $bonusvisit, @path);
        }
    }
}

sub MAIN() {
    my %graph;

    for  './input/day12.input'.IO.lines -> $line {
        my ($from, $to) = $line.split(/'-'/);
        %graph{$from}.push($to);
        %graph{$to}.push($from);
    }

    my %visited = %graph.keys.map({ $_ => 0; });
    my $count = 0;
    my $bonusvisit = True;

    visit('start', $count, %graph, %visited, $bonusvisit, ());
    say $count;
}

