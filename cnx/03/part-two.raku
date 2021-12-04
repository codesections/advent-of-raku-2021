sub filter(&op, @report, $column=0) {
    return parse-base @report[0].join, 2 unless @report.elems > 1;
    my $common = ([+] map *[$column], @report) > (@report.elems - 1) div 2;
    filter &op, (grep { op $_[$column], $common }, @report), $column + 1
}

my $input = map *.comb, words slurp 'input';
put [*] map { filter $_, $input }, (&infix:<==>, &infix:<!=>)
