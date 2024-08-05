using HotChocolate.AspNetCore;
using Serilog;
using Serilog.Debugging;
using Svc.Extensions.Logging.Serilog;
using Svc.T360.Ticket.DependencyInjection;

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .Enrich.FromLogContext()
    .CreateLogger();

SelfLog.Enable(Console.Error);

try
{
    // options
    var options = new WebApplicationOptions
    {
        Args = args,
        //ContentRootPath = WindowsServiceHelpers.IsWindowsService()
        //    ? AppContext.BaseDirectory
        //    : default
        ContentRootPath = default
    };
    Environment.CurrentDirectory = AppContext.BaseDirectory;

    // create builder
    var builder = WebApplication.CreateBuilder(options);

    // add health checks
    builder.Services.AddHealthChecks();

    // add additional configuration(s)
    builder.Configuration.AddJsonFile("app.serilog.json");
    builder.Configuration.AddJsonFile("app.configuration.json");
    builder.Configuration.AddEnvironmentVariables(prefix: "TICKET360_");

    // clears existing console logging
    builder.Logging.ClearProviders();

    // add Loggly
    builder.Services.AddLogging(l =>
    {
        l.AddSerilogLogglyConfiguration(builder.Configuration);
    });
    builder.Host.UseSerilog((context, provider, config) =>
        config.ReadFrom.Configuration(builder.Configuration)
            .Enrich.FromLogContext());

    // application dependencies
    builder.Services.AddApplicationDependencies();

    // graphQL dependencies
    builder.Services.AddGraphQLDependencies();

    // use windows service
    //builder.Host.UseWindowsService();

    // build
    var app = builder.Build();

    // logger
    var logger = app.Services.GetRequiredService<ILogger<Program>>();

    // log starting
    logger.LogInformation("[application][starting]");

    // map health check endpoint
    app.MapHealthChecks("/health");

    // graphQL options
    app.MapGraphQL()
        .WithOptions(new GraphQLServerOptions
        {
            Tool =
            {
                Title = "T360|Ticket",
                ServeMode = GraphQLToolServeMode.Embedded
            }
        });

    // log started
    app.Lifetime.ApplicationStarted.Register(() => logger.LogInformation("[application][started]"));

    // log stopping
    app.Lifetime.ApplicationStopping.Register(() => logger.LogInformation("[application][stopping]"));

    // log stopped
    app.Lifetime.ApplicationStopped.Register(() => logger.LogInformation("[application][stopped]"));

    // run
    app.Run();
}
catch (Exception ex)
{
    Log.Fatal(ex, "[application][unhandled_exception]");
}
finally
{
    Log.CloseAndFlush();
}
