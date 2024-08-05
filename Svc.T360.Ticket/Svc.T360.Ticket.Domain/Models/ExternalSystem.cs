using Svc.Extensions.Core.Model;
using Svc.T360.Ticket.Domain.Models.Data;
using System.ComponentModel.DataAnnotations;

namespace Svc.T360.Ticket.Domain.Models;
public class ExternalSystem : IModel
{
    [Key]
    public int ExternalSystemId { get; set; }
    public Guid ExternalSystemUid { get; set; }
    public DateTime CreateDateTime { get; set; }
    public DateTime UpdateDateTime { get; set; }
    public string ExternalSystemCode { get; set; } = "";
    public string ExternalSystemName { get; set; } = "";
    public ExternalSystemData? Data { get; set; }
}
