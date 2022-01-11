#!/usr/bin/raku

sub MAIN() {
    my $isTemplate = True;
    my $template;
    my %rules;

    for './input/day14.input'.IO.lines -> $line {
        if $line eq q{} {
            $isTemplate = False;
            next;
        }
        if $isTemplate {
            $template = $line;
        } else {
            my ($first, $second, $value) = $line.match(/(.)(.) ' -> ' (.)/).List;
            %rules{"$first$second"} = [$first, $value, $second];
        }
    }

    for 0 ..^ 10 {
        my @newtemplate = $template.comb;
        my $offset = -1;
        for 0 ..^ $template.chars - 1 -> $pos {
            my $pair = $template.substr($pos, 2);
            if %rules{$pair}:exists {
                $offset++;
                @newtemplate.splice($pos + $offset, 2, %rules{$pair});
            }
        }
        $template = @newtemplate.join;
    }

    say [-] [
        $template
        .comb
        .classify({ $_; } )
        .map({ .key => .value.elems; })
        .sort({ $^b.value <=> $^a.value })
        .map({ $_.value; })
    ][0, *-1];
}
