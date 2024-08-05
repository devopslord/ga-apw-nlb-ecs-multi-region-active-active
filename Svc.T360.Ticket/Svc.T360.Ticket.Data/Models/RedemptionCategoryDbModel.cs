using Svc.Extensions.Db.Data.Abstractions;
using Svc.Extensions.Db.Data.Abstractions.Attributes;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Svc.T360.Ticket.Data.Models;

[Table("redemption_categories")]
internal class RedemptionCategoryDbModel : IDbModel
{
    [Key]
    [Required]
    public int RedemptionCategoryId { get; set; }
    public Guid RedemptionCategoryUid { get; set; }
    public DateTime CreateDateTime { get; set; }
    public DateTime UpdateDateTime { get; set; }
    [StringKey]
    public string RedemptionCategoryCode { get; set; } = "";
    public string RedemptionCategoryName { get; set; } = "";
    public int RedemptionCategoryGroupId { get; set; }
}
