using Microsoft.Extensions.DependencyInjection;
using Svc.Extensions.Odm.DependencyInjection;
using Svc.Extensions.Service.Dto;
using Svc.T360.Ticket.Domain.Models;
using Svc.T360.Ticket.Service.Dto.DataProvider;
using Svc.T360.Ticket.Service.Dto.Mappers;
using Svc.T360.Ticket.Service.Dto.Models;
using Svc.T360.Ticket.Service.Dto.PropertySetters;

namespace Svc.T360.Ticket.Service.Dto.DependencyInjection;
public static class ServiceCollectionExtensions
{
    public static void AddDtoServiceDependencies(this IServiceCollection services)
    {
        // services
        services.AddDtoServices();

        // property setters
        services.AddPropertySetters();

        // odm types
        services.AddOdmTypes();
    }

    private static void AddDtoServices(this IServiceCollection services)
    {
        services.AddDtoService<ExternalSystem, ExternalSystemDto, ExternalSystemMapper, BaseDtoServiceDataProvider<ExternalSystem>>();
    }

    private static void AddPropertySetters(this IServiceCollection services)
    {
        services.AddPropertySetter<ExternalSystemDto, ExternalSystemDescriptionSetter>();
        services.AddPropertySetter<ExternalSystemDto, ExternalSystemPreviousRecordNameSetter>();
    }

    private static void AddOdmTypes(this IServiceCollection services)
    {
        services.AddOdmType<ExternalSystemDto>();
    }
}
