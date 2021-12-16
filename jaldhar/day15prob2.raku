#!/usr/bin/raku

class PriorityQueue {

    class Element {
        has Any $.value is rw;
        has Int $.priority is rw;
    }

    has Element @!queue = ();

    method clear() {
        @!queue = ();
    }

    method top() {
        return @!queue[0].value;
    }

    method empty() {
        return @!queue.elems == 0;
    }

    method pop() {
        if !self.empty {
            return @!queue.pop.value;
        }
        return Nil;
    }

    method push(Any $value, Int $priority = 0) {
        my $pos = 0;
        while $pos < @!queue.elems && @!queue[$pos].priority >= $priority {
            $pos++;
        }
        my @remainder = @!queue.splice($pos, @!queue.elems - $pos);
        @!queue.push(
            Element.new(value => $value, priority => $priority),
        ).append(@remainder);
    }

    method size() {
        return @!queue.elems;
    }
}

sub inbounds(@riskmap, Int $row, Int $col) {
    return $row >= 0 && $row < @riskmap.elems && $col >= 0 &&
    $col < @riskmap[$row].elems;
}

sub MAIN() {
    my @riskmap;
    my @submap =  './input/day15.input'.IO.lines.map({ $_.comb; });
    for 0 ..^ @submap.elems -> $i {
        for 0 ..^ @submap[$i].elems -> $j {
            for 0 .. 4 -> $k {
                for 0 .. 4 -> $l {
                    my $score = @submap[$i;$j] + ($k + $l);
                    if $score > 9 {
                        $score -= 9;
                    }
                    @riskmap[($k * @submap.elems) + $i;($l * @submap[$j].elems) + $j] = $score;
                }
            }
        }
    }

    my @start = 0, 0;
    my @end = @riskmap.elems - 1, @riskmap[0].elems - 1;
    my PriorityQueue $q = PriorityQueue.new;
    $q.push(@start, 0);
    my %visited;
    %visited{@start.join(q{-})} = Nil;
    my %cost;
    %cost{@start.join(q{-})} = 0;
    my @dirs = (0, -1), (-1, 0), (0, 1), (1, 0);
 
    while !$q.empty() {
        my @current = $q.pop().flat;
 
        if @current ~~ @end {
            last;
        }

        for @dirs -> @dir {
            my @next = @current Z+ @dir;
            if !inbounds(@riskmap, @next[0], @next[1]) {
                next;
            }
            my $newCost = %cost{@current.join(q{-})} + @riskmap[@next[0]][@next[1]];
            if  %cost{@next.join(q{-})}:!exists || $newCost < %cost{@next.join(q{-})} {
                %cost{@next.join(q{-})} = $newCost;
                $q.push(@next, $newCost);
                %visited{@next.join(q{-})} = @current.join(q{-});

            }
        }
    }

    my $current = @end.join(q{-});
    my @path;
    while $current {
        @path.unshift($current.split(q{-}));
        $current = %visited{$current};
    }
    say ([+] @path.map({ @riskmap[$_[0]][$_[1]] })) - @riskmap[@start[0]][@start[1]];
}
