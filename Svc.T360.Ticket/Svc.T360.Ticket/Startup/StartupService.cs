using Svc.Extensions.Hosting.Startup;

namespace Svc.T360.Ticket.Startup;

public class StartupService(ILogger<StartupService> logger, IServiceScopeFactory serviceScopeFactory) 
    : IStartupService
{
    public async Task ExecuteAsync()
    {
        try
        {
            logger.LogInformation("[startup_service][start]");

            using (var scope = serviceScopeFactory.CreateScope())
            {
                // {Scoped health check code here}

                //var svc = scope.ServiceProvider.GetService<IBaseDtoService<ProductType, ProductTypeDto>>();
                //if (svc is not null)
                //{
                //    _ = await svc.GetAllAsync();
                //}

            }

            logger.LogInformation("[startup_service][complete]");
        }
        catch (Exception e)
        {
            logger.LogError(e, "[startup_service][error] {ErrorMessage}", e.Message);
        }
    }
}
