# initialize flags and suppressed line count
function init() {
    suppress=0; # whether we are currently inside a snip
    scount = 0; # count of suppressed lines
    stub = 0;   # whether the user has provided a stub
}
BEGIN { init(); }

# start of a snip
/<snip>/ { suppress = 1; }

# count the number of suppressed lines
suppress { scount++; }

# print comment lines within snips
suppress && /\/\// && !/snip/ && !/STUB2:/ { print; } 

# print regular lines outside snips and stubs
!suppress && !/STUB2:/ { print; }

# user-provided stub
# should be placed inside the snip, probably at the end
/STUB2:/ {
    stub = 1;
    sub(/\/\/ STUB2: */, "");
    print $0, "// TODO: replace this stub";
}

# end of a snip
/<\/snip>/ { 
    if (scount < 10) {
        msg = "short code snippet";
    } else {
        msg = "longer code snippet";
    }
    # standard snip replacement if user did not provide a custom stub
    if (!stub) {
        print "// TODO: " msg;
        print "throw new ece351.util.Todo351Exception();"
    }   
    init();
}

/^\\begin{solution}/ { suppress=1; print "TODO"; }
/^\\end{solution}/   { suppress=0; print; }
