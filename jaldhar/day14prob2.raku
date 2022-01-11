#!/usr/bin/raku

sub MAIN() {
    my $isTemplate = True;
    my $template;
    my %rules;
    my $extra;

    for './input/day14.input'.IO.lines -> $line {
        if $line eq q{} {
            $isTemplate = False;
            next;
        }
        if $isTemplate {
            $template = $line;
            $extra = $line.substr(*-1, 1);
        } else {
            my ($first, $second, $insert) = $line.match(/(.)(.) ' -> ' (.)/).List;
            %rules{"$first$second"} = "$insert";
        }
    }

    my %frequency;
    for 0 ..^ $template.chars -> $pos {
        my $pair = $template.substr($pos, 2);
        if %rules{$pair}:exists {
            %frequency{$pair}++;
        }
    }

    for 0 ..^ 40 {
        my %temp;

        for %frequency -> $pair {
            my ($first, $second) = $pair.key.comb;
            $first ~= %rules{$pair.key};
            $second = %rules{$pair.key} ~ $second;
            %temp{$first} += $pair.value;
            %temp{$second} += $pair.value;
        }

        %frequency = %temp;
    }

    my %count;

    for %frequency -> $pair {
        %count{$pair.key.substr(0,1)} += $pair.value;
    }

    %count{$extra}++;

    say %count.values.max - %count.values.min;
}
