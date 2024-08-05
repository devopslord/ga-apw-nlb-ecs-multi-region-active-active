using HotChocolate;
using HotChocolate.Resolvers;
using HotChocolate.Types;
using Svc.Extensions.Api.GraphQL.Abstractions;
using Svc.Extensions.Api.GraphQL.HotChocolate;
using Svc.Extensions.Odm.HotChocolate;
using Svc.Extensions.Service;
using Svc.T360.Ticket.Domain.Filters;
using Svc.T360.Ticket.Domain.Models;

namespace Svc.T360.Ticket.GraphQL.Queries;

[ExtendObjectType(nameof(Query))]
public class RedemptionCategoryQuery
{
    public async Task<GraphQLResponse<IEnumerable<RedemptionCategory>>> GetRedemptionCategoriesAsync(IResolverContext context,
        [Service] IQueryOperation operation, [Service] IBaseService<RedemptionCategory> svc)
        => await operation.ExecuteAsync(nameof(GetRedemptionCategoriesAsync),
            async () => await svc.GetAllAsync(context.ToObjectDefinition(GraphQLResponsePropertyNames.Content)) ??
                        Enumerable.Empty<RedemptionCategory>());

    public async Task<GraphQLResponse<IEnumerable<RedemptionCategory>>> GetRedemptionCategoriesByIdsAsync(IResolverContext context, List<long> idCollection,
        [Service] IQueryOperation operation, [Service] IBaseService<RedemptionCategory> svc)
        => await operation.ExecuteAsync(nameof(GetRedemptionCategoriesByIdsAsync),
            async () => await svc.GetAllAsync(idCollection, context.ToObjectDefinition(GraphQLResponsePropertyNames.Content)) ??
                        Enumerable.Empty<RedemptionCategory>());

    public async Task<GraphQLResponse<RedemptionCategory?>> GetRedemptionCategoryAsync(IResolverContext context, long id,
        [Service] IQueryOperation operation, [Service] IBaseService<RedemptionCategory> svc)
        => await operation.ExecuteAsync(nameof(GetRedemptionCategoryAsync),
            async () => await svc.GetAsync(id, context.ToObjectDefinition(GraphQLResponsePropertyNames.Content)));

    public async Task<GraphQLResponse<RedemptionCategory?>> GetRedemptionCategoryByStringIdAsync(IResolverContext context, string id,
        [Service] IQueryOperation operation, [Service] IBaseService<RedemptionCategory> svc)
        => await operation.ExecuteAsync(nameof(GetRedemptionCategoryByStringIdAsync),
            async () => await svc.GetAsync(id, context.ToObjectDefinition(GraphQLResponsePropertyNames.Content)));

    public async Task<GraphQLResponse<IEnumerable<RedemptionCategory>?>> GetRedemptionCategoryByFilterAsync(IResolverContext context, RedemptionCategoryFilter filter,
        [Service] IQueryOperation operation, [Service] IBaseService<RedemptionCategory> svc)
        => await operation.ExecuteAsync(nameof(GetRedemptionCategoryByFilterAsync),
            async () => await svc.GetAllByFilterAsync(filter, context.ToObjectDefinition(GraphQLResponsePropertyNames.Content)));
}
