namespace Svc.T360.Ticket.GraphQL.Extensions;

public static class CollectionExtensions
{
    public static IEnumerable<T> OrEmptyEnumerable<T>(this IEnumerable<T>? collection)
        => collection ?? Enumerable.Empty<T>();
}
