using HotChocolate;
using HotChocolate.Types;
using Svc.Extensions.Api.GraphQL.Abstractions;
using Svc.Extensions.Api.GraphQL.HotChocolate;
using Svc.Extensions.Core.Model;
using Svc.Extensions.Service;
using Svc.T360.Ticket.Domain.Models;
using Svc.T360.Ticket.GraphQL.InputTypes;

namespace Svc.T360.Ticket.GraphQL.Mutations;

[ExtendObjectType(nameof(Mutation))]
public class ExternalSystemMutation
{
    public async Task<GraphQLResponse<ExternalSystem?>> ExternalSystemSaveAsync(ExternalSystemSaveInput input,
        [Service] IMutationOperation operation, [Service] IBaseService<ExternalSystem> svc)
        => await operation.ExecuteAsync(nameof(ExternalSystemSaveAsync),
            async () => await svc.SaveAsync(input.ConvertToModel<ExternalSystemSaveInput, ExternalSystem>()));

    public async Task<GraphQLResponse<IEnumerable<ExternalSystem>>> ExternalSystemsSaveAsync(IEnumerable<ExternalSystemSaveInput> input,
        [Service] IMutationOperation operation, [Service] IBaseService<ExternalSystem> svc)
        => await operation.ExecuteAsync(nameof(ExternalSystemsSaveAsync),
            async () => await svc.SaveAsync(input.Select(x => x.ConvertToModel<ExternalSystemSaveInput, ExternalSystem>()).ToList()));

    //public async Task<GraphQLResponse<IEnumerable<ExternalSystem>>> ExternalSystemsSaveAsync(IEnumerable<ExternalSystemSaveInput> input,
    //    [Service] IMutationOperation operation, [Service] IBaseService<ExternalSystem> svc)
    //    => await operation.ExecuteAsync(nameof(ExternalSystemSaveAsync),
    //        async () =>
    //        {
    //            var list = input.ToList();

    //            var item = list.FirstOrDefault();
    //            if (item is null)
    //                return Enumerable.Empty<ExternalSystem>();

    //            var cnt = 20000;
    //            var ticks = DateTime.Now.Ticks;
    //            for (var i = 0; i < cnt; i++)
    //            {
    //                var newItem = new ExternalSystemSaveInput().Copy(item);
    //                newItem.ExternalSystemId = 0;
    //                newItem.ExternalSystemCode = $"FROM-BULK-{ticks}-{i}";
    //                newItem.ExternalSystemName = $"From Bulk Save [{i}]";

    //                list.Add(newItem);
    //            }

    //            var result = await svc.SaveAsync(list.Select(x => x.ConvertToModel<ExternalSystemSaveInput, ExternalSystem>())
    //                .ToList());
    //            return result;
    //        });
}
