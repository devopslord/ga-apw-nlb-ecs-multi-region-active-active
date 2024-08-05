using Svc.Extensions.Core.Model;
using System.ComponentModel.DataAnnotations;

namespace Svc.T360.Ticket.Domain.Models;
public class RedemptionCategory : IModel
{
    [Key]
    public int RedemptionCategoryId { get; set; }
    public Guid RedemptionCategoryUid { get; set; }
    public DateTime CreateDateTime { get; set; }
    public DateTime UpdateDateTime { get; set; }
    public string RedemptionCategoryCode { get; set; } = "";
    public string RedemptionCategoryName { get; set; } = "";
    public int RedemptionCategoryGroupId { get; set; }
}
