function plotRINEXpickle(filename)
arguments
  filename (1,1) string
end

keys = ["C1C", "L1C", "D1C", "S1C", "C5Q", "L5Q", "D5Q", "S5Q"];

[dat, sv] = loadRINEXpickle(filename, keys);

for j = 1:length(keys)
  f = figure(j);
  clf(f)
  ax = axes(f, NextPlot="add");
  title(ax, keys(j))

  for i = 1:length(sv)
    disp(sv(i) + " " + keys(j))
    plot(ax, dat.(keys(j))(:,i), DisplayName=sv(i))
  end
end

legend("show")

end
