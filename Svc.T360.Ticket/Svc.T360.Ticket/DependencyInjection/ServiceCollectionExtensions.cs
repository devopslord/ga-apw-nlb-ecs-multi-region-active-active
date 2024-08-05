using Svc.Extensions.Api.GraphQL.Abstractions;
using Svc.Extensions.Api.GraphQL.HotChocolate;
using Svc.Extensions.Api.Operation;
using Svc.Extensions.Hosting.Startup;
using Svc.Extensions.Security;
using Svc.T360.Ticket.Data.DependencyInjection;
using Svc.T360.Ticket.GraphQL.Mutations;
using Svc.T360.Ticket.GraphQL.Queries;
using Svc.T360.Ticket.Service.DependencyInjection;
using Svc.T360.Ticket.Service.Dto.DependencyInjection;
using Svc.T360.Ticket.Startup;
using System.Net;

namespace Svc.T360.Ticket.DependencyInjection;

public static class ServiceCollectionExtensions
{
    public static void AddGraphQLDependencies(this IServiceCollection services)
    {
        // Operations
        services.UseGraphQLOperations();

        // Exception Mappings
        GraphQLResponseHelper.AddExceptionResponseMap<AuthException>(HttpStatusCode.Unauthorized);

        // GraphQL
        services.UseGraphQL()
            .UseQueryType()
            .UseMutationType()
            .AddPingQuery()
            .AddHealthQuery()
            // queries
            .AddType<ExternalSystemQuery>()
            .AddType<RedemptionCategoryQuery>()
            .AddType<TestQuery>()
            // mutations
            .AddType<ExternalSystemMutation>();
    }

    public static void AddApplicationDependencies(this IServiceCollection services)
    {
        // Startup
        services.AddStartupService<StartupService>();

        // Data
        services.AddDataDependencies();

        // Service
        services.AddServiceDependencies();

        // Dto Service
        services.AddDtoServiceDependencies();

        // External
        services.AddExternalDataDependencies();
    }

    private static void AddExternalDataDependencies(this IServiceCollection services)
    {
        // Quest
        //services.AddQuest();

        // External Data
        //services.AddExternalTicketDependencies();
    }
}
