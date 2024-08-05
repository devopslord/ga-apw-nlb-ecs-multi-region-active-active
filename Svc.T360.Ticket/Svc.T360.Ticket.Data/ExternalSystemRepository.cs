using Microsoft.Extensions.Logging;
using Svc.Extensions.Db.Data.Abstractions;
using Svc.T360.Ticket.Data.Abstractions;
using Svc.T360.Ticket.Data.Models;
using Svc.T360.Ticket.Domain.Models;

namespace Svc.T360.Ticket.Data;

internal class ExternalSystemRepository(IDbRepositoryAdapter<ExternalSystem> repositoryAdapter, ILogger<ExternalSystemRepository> logger)
    : DbRepository<ExternalSystem, ExternalSystemDbModel>(repositoryAdapter), IExternalSystemRepository
{
    public override Task<int> DeleteAsync(ExternalSystem item)
    {
        logger.LogDebug("Deleting external system {ExternalSystemId}", item.ExternalSystemId);

        return base.DeleteAsync(item);
    }
}
