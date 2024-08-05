using Svc.Extensions.Odm.Attributes;
using Svc.Extensions.Service.Dto;
using Svc.T360.Ticket.Domain.Models;
using Svc.T360.Ticket.Domain.Models.Data;

namespace Svc.T360.Ticket.Service.Dto.Models;
public class ExternalSystemDto : IDtoModel<ExternalSystem>
{
    public int ExternalSystemId { get; set; }
    public Guid ExternalSystemUid { get; set; }
    public DateTime CreateDateTime { get; set; }
    public DateTime UpdateDateTime { get; set; }
    public string ExternalSystemCode { get; set; } = "";
    public string ExternalSystemName { get; set; } = "";
    public ExternalSystemData? Data { get; set; }

    #region Property Setter Properties
    
    [OdmRequiredProperty(nameof(ExternalSystemCode))]
    [OdmRequiredProperty(nameof(ExternalSystemName))]
    public string? Description { get; set; }

    public string? PreviousRecordName { get; set; }

    #endregion
}
