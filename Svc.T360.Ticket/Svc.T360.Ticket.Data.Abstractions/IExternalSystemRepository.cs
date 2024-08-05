using Svc.Extensions.Db.Data.Abstractions.Core;
using Svc.T360.Ticket.Domain.Models;

namespace Svc.T360.Ticket.Data.Abstractions;
public interface IExternalSystemRepository : IDbRepository<ExternalSystem>
{
}
