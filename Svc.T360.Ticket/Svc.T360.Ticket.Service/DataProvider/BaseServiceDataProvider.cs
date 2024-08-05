using Svc.Extensions.Core.Filter;
using Svc.Extensions.Core.Model;
using Svc.Extensions.Db.Data.Abstractions.Core;
using Svc.Extensions.Odm.Abstractions;
using Svc.Extensions.Service;

namespace Svc.T360.Ticket.Service.DataProvider;
internal class BaseServiceDataProvider<T>(IDbDataProvider dataProvider)
    : IBaseServiceDataProvider<T>
    where T : class, IModel
{
    public Task<T?> GetAsync(long id, ObjectDefinition? definition = null)
        => dataProvider.Repo<T>().GetAsync(id, definition);

    public Task<T?> GetAsync(string id, ObjectDefinition? definition = null)
        => dataProvider.Repo<T>().GetAsync(id, definition);

    public Task<IEnumerable<T>?> GetAllAsync(ObjectDefinition? definition = null)
        => dataProvider.Repo<T>().GetAllAsync(definition);

    public Task<IEnumerable<T>?> GetAllAsync(List<long> ids, ObjectDefinition? definition = null)
        => dataProvider.Repo<T>().GetAllAsync(ids, definition);

    public Task<IEnumerable<T>?> GetAllByForeignKeyAsync<TType>(long id, ObjectDefinition? definition = null)
        => dataProvider.Repo<T>().GetAllByForeignKeyAsync<TType>(id, definition);

    public Task<IEnumerable<T>?> GetAllByForeignKeyAsync<TType>(List<long> ids, ObjectDefinition? definition = null)
        => dataProvider.Repo<T>().GetAllByForeignKeyAsync<TType>(ids, definition);

    public Task<IEnumerable<T>?> GetAllByFilterAsync<TFilter>(TFilter filter, ObjectDefinition? definition = null)
        where TFilter : IFilter<T>
        => dataProvider.Repo<T>().GetAllByFilterAsync(filter, definition);

    public Task<T?> SaveAsync(T? item)
        => dataProvider.Repo<T>().SaveAsync(item);

    public Task<IEnumerable<T>> SaveAsync(List<T> items)
        => dataProvider.Repo<T>().SaveAsync(items);

    public Task<int> DeleteAsync(T item)
        => dataProvider.Repo<T>().DeleteAsync(item);
}
