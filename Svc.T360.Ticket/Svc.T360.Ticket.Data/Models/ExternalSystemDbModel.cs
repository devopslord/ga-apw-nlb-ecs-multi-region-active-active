using Svc.Extensions.Db.Data.Abstractions;
using Svc.Extensions.Db.Data.Abstractions.Attributes;
using Svc.T360.Ticket.Domain.Models.Data;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Svc.T360.Ticket.Data.Models;

[Table("external_systems")]
internal class ExternalSystemDbModel : IDbModel
{
    [Key]
    public int ExternalSystemId { get; set; }
    [GuidKey]
    public Guid ExternalSystemUid { get; set; }
    [CreatedDateTimeProperty]
    public DateTime CreateDateTime { get; set; }
    [UpdatedDateTimeProperty]
    public DateTime UpdateDateTime { get; set; }
    [StringKey]
    public string ExternalSystemCode { get; set; } = "";
    public string ExternalSystemName { get; set; } = "";
    [Editable(true)]
    public ExternalSystemData? Data { get; set; }
}
