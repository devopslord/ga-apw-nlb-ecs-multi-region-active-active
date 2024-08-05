using Svc.Extensions.Odm.Abstractions;
using Svc.Extensions.Service.Dto;
using Svc.T360.Ticket.Domain.Models;
using Svc.T360.Ticket.Service.Dto.Models;

namespace Svc.T360.Ticket.Service.Dto.PropertySetters;
internal class ExternalSystemPreviousRecordNameSetter(IBaseDtoService<ExternalSystem, ExternalSystemDto> service) : IPropertySetter<ExternalSystemDto>
{
    public string PropertyName => nameof(ExternalSystemDto.PreviousRecordName);

    public async Task Set(ExternalSystemDto obj, ObjectDefinition? def)
    {
        var lookupId = obj.ExternalSystemId - 1;
        var result = await service.GetAsync(lookupId, def);
        if (result is null)
            return;

        obj.PreviousRecordName = $"PREVIOUS RECORD: {result.ExternalSystemName}";
    }

    public async Task Set(List<ExternalSystemDto> collection, ObjectDefinition? def)
    {
        var lookupIds = collection.Select(x => (long)(x.ExternalSystemId - 1)).ToList();
        var results = (await service.GetAllAsync(lookupIds, def))?.ToList();
        if (results is null)
            return;

        foreach (var item in collection)
        {
            var result = results.FirstOrDefault(x => x.ExternalSystemId == (item.ExternalSystemId - 1));
            if (result is null) 
                continue;

            item.PreviousRecordName = $"PREVIOUS RECORD: {result.ExternalSystemName}";
        }
    }
}
