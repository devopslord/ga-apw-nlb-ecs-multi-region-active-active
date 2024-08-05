using Svc.Extensions.Core.Model;
using System.ComponentModel.DataAnnotations;

namespace Svc.T360.Ticket.Domain.Models;
public class RedemptionCategoryGroup : IModel
{
    [Key]
    public int RedemptionCategoryGroupId { get; set; }
    public Guid RedemptionCategoryGroupUid { get; set; }
    public DateTime CreateDateTime { get; set; }
    public DateTime UpdateDateTime { get; set; }
    public string RedemptionCategoryGroupCode { get; set; } = "";
    public string RedemptionCategoryGroupName { get; set; } = "";
    public bool IsMultiplesAllowed { get; set; }
}
