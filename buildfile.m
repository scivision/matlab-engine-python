function plan = buildfile

plan = buildplan();

plan.DefaultTasks = "test";

addpath(plan.RootFolder)


plan("check") = matlab.buildtool.tasks.CodeIssuesTask(".", IncludeSubfolders=true);
plan("test") = matlab.buildtool.tasks.TestTask("test", Strict=false);

end
