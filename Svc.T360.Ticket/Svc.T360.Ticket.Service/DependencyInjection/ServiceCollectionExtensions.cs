using Microsoft.Extensions.DependencyInjection;
using Svc.Extensions.Service;
using Svc.T360.Ticket.Domain.Models;
using Svc.T360.Ticket.Service.DataProvider;

namespace Svc.T360.Ticket.Service.DependencyInjection;
public static class ServiceCollectionExtensions
{
    public static void AddServiceDependencies(this IServiceCollection services)
    {
        // Services
        services.AddBaseServices();
        services.AddServices();
    }

    private static void AddBaseServices(this IServiceCollection services)
    {
        services.AddBaseServiceType<ExternalSystem, BaseServiceDataProvider<ExternalSystem>>();
        services.AddBaseServiceType<RedemptionCategory, BaseServiceDataProvider<RedemptionCategory>>();
        services.AddBaseServiceType<RedemptionCategoryGroup, BaseServiceDataProvider<RedemptionCategoryGroup>>();
    }

    private static void AddServices(this IServiceCollection services)
    {
        //services.AddScoped<ITicketService, TicketService>();
    }
}
