using Svc.Extensions.Core.Model;
using Svc.T360.Ticket.Domain.Models;
using Svc.T360.Ticket.Domain.Models.Data;

namespace Svc.T360.Ticket.GraphQL.InputTypes;

public class ExternalSystemSaveInput : IModelDto<ExternalSystem>
{
    public int ExternalSystemId { get; set; }
    public string ExternalSystemCode { get; set; } = "";
    public string ExternalSystemName { get; set; } = "";
    public ExternalSystemData? Data { get; set; }
}
