using Svc.Extensions.Odm.Abstractions;
using Svc.T360.Ticket.Service.Dto.Models;

namespace Svc.T360.Ticket.Service.Dto.PropertySetters;
internal class ExternalSystemDescriptionSetter : IPropertySetter<ExternalSystemDto>
{
    public string PropertyName => nameof(ExternalSystemDto.Description);

    public async Task Set(ExternalSystemDto obj, ObjectDefinition? def)
    {
        obj.Description = await Task.FromResult($"[{obj.ExternalSystemCode}] {obj.ExternalSystemName}");
    }

    public async Task Set(List<ExternalSystemDto> collection, ObjectDefinition? def)
    {
        foreach (var obj in collection)
        {
            obj.Description = await Task.FromResult($"[{obj.ExternalSystemCode}] {obj.ExternalSystemName}");
        }
    }
}
