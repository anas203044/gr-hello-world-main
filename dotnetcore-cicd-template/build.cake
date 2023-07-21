#tool nuget:?package=Cake.FileHelpers

var target = Argument("target", "Default");
var configuration = Argument("configuration", "Release");

Task("Clean")
  .Does(() =>
{
  CleanDirectory("./src/HelloWorld/bin/" + configuration);
});

Task("Restore")
  .IsDependentOn("Clean")
  .Does(() =>
{
  DotNetCoreRestore("./src/HelloWorld/HelloWorld.csproj");
});

Task("Build")
  .IsDependentOn("Restore")
  .Does(() =>
{
  DotNetCoreBuild("./src/HelloWorld/HelloWorld.csproj", new DotNetCoreBuildSettings
  {
    Configuration = configuration
  });
});

Task("Test")
  .IsDependentOn("Build")
  .Does(() =>
{
  DotNetCoreTest("./test/HelloWorld.Tests/HelloWorld.Tests.csproj", new DotNetCoreTestSettings
  {
    Configuration = configuration
  });
});

Task("Default")
  .IsDependentOn("Test");

RunTarget(target);

