using Svc.Extensions.Db.Data.Abstractions;
using Svc.Extensions.Db.Data.Abstractions.Attributes;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Svc.T360.Ticket.Data.Models;

[Table("redemption_category_groups")]
internal class RedemptionCategoryGroupDbModel : IDbModel
{
    [Key]
    [Required]
    public int RedemptionCategoryGroupId { get; set; }
    public Guid RedemptionCategoryGroupUid { get; set; }
    public DateTime CreateDateTime { get; set; }
    public DateTime UpdateDateTime { get; set; }
    [StringKey]
    public string RedemptionCategoryGroupCode { get; set; } = "";
    public string RedemptionCategoryGroupName { get; set; } = "";
    public bool IsMultiplesAllowed { get; set; }
}
