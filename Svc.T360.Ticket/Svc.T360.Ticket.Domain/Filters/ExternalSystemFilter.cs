using Svc.Extensions.Core.Filter;
using Svc.Extensions.Core.Value;
using Svc.T360.Ticket.Domain.Models;

namespace Svc.T360.Ticket.Domain.Filters;
public class ExternalSystemFilter : DefaultFilter, IFilter<ExternalSystem>
{
    public PropertyValue<List<Guid>>? ExternalSystemUidCollection { get; set; }
    public PropertyValue<Guid>? ExternalSystemUid { get; set; }
}
