using Svc.Extensions.Core.Filter;
using Svc.Extensions.Core.Value;
using Svc.T360.Ticket.Domain.Models;

namespace Svc.T360.Ticket.Domain.Filters;
public class RedemptionCategoryFilter : DefaultFilter, IFilter<RedemptionCategory>
{
    public PropertyValue<List<Guid>>? RedemptionCategoryUidCollection { get; set; }
    public PropertyValue<Guid>? RedemptionCategoryUid { get; set; }
    public PropertyValue<int>? RedemptionCategoryGroupId { get; set; }
}
