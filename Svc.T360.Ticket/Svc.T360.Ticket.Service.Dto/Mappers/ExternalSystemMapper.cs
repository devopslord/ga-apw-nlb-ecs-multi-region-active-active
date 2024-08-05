using Riok.Mapperly.Abstractions;
using Svc.Extensions.Service.Dto;
using Svc.T360.Ticket.Domain.Models;
using Svc.T360.Ticket.Service.Dto.Models;

namespace Svc.T360.Ticket.Service.Dto.Mappers;

[Mapper]
public partial class ExternalSystemMapper : IMapper<ExternalSystem, ExternalSystemDto>
{
    public static partial ExternalSystemDto ToDto(ExternalSystem source);
    public static partial ExternalSystem ToModel(ExternalSystemDto source);
}
