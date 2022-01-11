#!/usr/bin/raku

sub visit($dest, $count is rw, %graph, %visited is copy, @path is copy) {
    @path.push($dest);
    if $dest eq 'end' {
        @path.join(q{,}).say;
        $count++;
        return;
    }

    %visited{$dest}++;

    for %graph{$dest} -> @children {
        for @children -> $next {
            if $next.match(/^ <:Ll>+ $/).so && %visited{$next} > 0 {
                next;
            }
            visit($next, $count, %graph, %visited, @path);
        }
    }
}

sub MAIN() {
    my %graph;

    for  './input/day12.test'.IO.lines -> $line {
        my ($from, $to) = $line.split(/'-'/);
        %graph{$from}.push($to);
        %graph{$to}.push($from);
    }

    my %visited = %graph.keys.map({ $_ => 0; });
    my $count = 0;

    visit('start', $count, %graph, %visited, ());
    say $count;
}
