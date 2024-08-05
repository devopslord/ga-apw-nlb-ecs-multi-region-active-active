using HotChocolate;
using HotChocolate.Resolvers;
using HotChocolate.Types;
using Svc.Extensions.Api.GraphQL.Abstractions;
using Svc.Extensions.Api.GraphQL.HotChocolate;
using Svc.Extensions.Odm.HotChocolate;
using Svc.Extensions.Service.Dto;
using Svc.T360.Ticket.Domain.Filters;
using Svc.T360.Ticket.Domain.Models;
using Svc.T360.Ticket.GraphQL.Extensions;
using Svc.T360.Ticket.Service.Dto.Models;

namespace Svc.T360.Ticket.GraphQL.Queries;

[ExtendObjectType(nameof(Query))]
public class ExternalSystemQuery
{
    public async Task<GraphQLResponse<ExternalSystemDto?>> GetExternalSystemAsync(IResolverContext context, long id,
        [Service] IQueryOperation operation, [Service] IBaseDtoService<ExternalSystem, ExternalSystemDto> svc)
        => await operation.ExecuteAsync(nameof(GetExternalSystemAsync),
            async () => await svc.GetAsync(id, context.ToObjectDefinition(GraphQLResponsePropertyNames.Content)));

    public async Task<GraphQLResponse<ExternalSystemDto?>> GetExternalSystemByStringIdAsync(IResolverContext context, string id,
        [Service] IQueryOperation operation, [Service] IBaseDtoService<ExternalSystem, ExternalSystemDto> svc)
        => await operation.ExecuteAsync(nameof(GetExternalSystemByStringIdAsync),
            async () => await svc.GetAsync(id, context.ToObjectDefinition(GraphQLResponsePropertyNames.Content)));

    public async Task<GraphQLResponse<IEnumerable<ExternalSystemDto>>> GetExternalSystemsAsync(IResolverContext context,
        [Service] IQueryOperation operation, [Service] IBaseDtoService<ExternalSystem, ExternalSystemDto> svc)
        => await operation.ExecuteAsync(nameof(GetExternalSystemsAsync),
            async () => (await svc.GetAllAsync(context.ToObjectDefinition(GraphQLResponsePropertyNames.Content))).OrEmptyEnumerable());

    public async Task<GraphQLResponse<IEnumerable<ExternalSystemDto>>> GetExternalSystemsByIdsAsync(IResolverContext context, List<long> idCollection,
        [Service] IQueryOperation operation, [Service] IBaseDtoService<ExternalSystem, ExternalSystemDto> svc)
        => await operation.ExecuteAsync(nameof(GetExternalSystemsByIdsAsync),
            async () => (await svc.GetAllAsync(idCollection, context.ToObjectDefinition(GraphQLResponsePropertyNames.Content))).OrEmptyEnumerable());

    public async Task<GraphQLResponse<IEnumerable<ExternalSystemDto>>> GetExternalSystemByFilterAsync(IResolverContext context, ExternalSystemFilter filter,
        [Service] IQueryOperation operation, [Service] IBaseDtoService<ExternalSystem, ExternalSystemDto> svc)
        => await operation.ExecuteAsync(nameof(GetExternalSystemByFilterAsync),
            async () => (await svc.GetAllByFilterAsync(filter, context.ToObjectDefinition(GraphQLResponsePropertyNames.Content))).OrEmptyEnumerable());
}
