io = IOBuffer(read(`top -b -i -H -w 256 -d 1 -n 1`));  # takes 10 seconds

using TopParser
using PrettyTables

processes = collect(TopParser.processes(io));

using DataFrames

df = DataFrame(processes);  # `processes` is a table

seekstart(io);

samples = map(s -> collect(s.processes), TopParser.samples(io));

println(df)

pretty_table(df, sortkeys = true)
