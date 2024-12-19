%% DATETIME2PYDATETIME convert Matlab datetime scalar to Python datetime.datetime

function pdt = datetime2pydatetime(dt)

s = floor(second(dt));

us = (second(dt) - s) * 1e6;

pdt = py.datetime.datetime(int64(year(dt)), int64(month(dt)), int64(day(dt)), ...
    int64(hour(dt)), int64(minute(dt)), ...
    int64(s), int64(us));

end
