io = IOBuffer(read(`top -b -i -H -w 256 -d 1 -n 10`));  # takes 10 seconds

using TopParser

processes = collect(TopParser.processes(io));

using DataFrames

df = DataFrame(processes);  # `processes` is a table

seekstart(io);

samples = map(s -> collect(s.processes), TopParser.samples(io));
