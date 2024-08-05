using Audit.Core;
using Microsoft.Extensions.DependencyInjection;
using Svc.Extensions.AWS;
using Svc.Extensions.Db.Data.Postgres;
using Svc.T360.Ticket.Data.Audit;
using Svc.T360.Ticket.Data.Models;
using Svc.T360.Ticket.Data.TokenProvider;
using Svc.T360.Ticket.Domain.Models;
using Svc.T360.Ticket.Domain.Models.Data;

namespace Svc.T360.Ticket.Data.DependencyInjection;
public static class ServiceCollectionExtensions
{
    public static void AddDataDependencies(this IServiceCollection services)
    {
        // AWS
        services.UseAmazonRdsAuthTokenProvider();

        // Audit
        services.AddTransient<AuditDataProvider, DbAuditDataProvider>();
        
        // Postgres
        services.UsePostgresSqlServer<DbTokenProvider>();
        
        // Repos
        services.AddRepos();

        // Type Handlers
        AddTypeHandlers();
    }

    private static void AddRepos(this IServiceCollection services)
    {
        services.AddPostgresSqlRepoType<ExternalSystem, ExternalSystemDbModel, ExternalSystemRepository>();
        services.AddPostgresSqlRepoType<RedemptionCategory, RedemptionCategoryDbModel>();
        services.AddPostgresSqlRepoType<RedemptionCategoryGroup, RedemptionCategoryGroupDbModel>();
    }

    private static void AddTypeHandlers()
    {
        PostgresExtensions.AddJsonbTypeHandler<ExternalSystemData>();
    }
}
