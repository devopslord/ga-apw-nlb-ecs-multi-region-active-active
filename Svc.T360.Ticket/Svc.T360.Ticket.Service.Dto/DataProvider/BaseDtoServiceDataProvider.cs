using Svc.Extensions.Core.Filter;
using Svc.Extensions.Core.Model;
using Svc.Extensions.Odm.Abstractions;
using Svc.Extensions.Service;
using Svc.Extensions.Service.Dto;

namespace Svc.T360.Ticket.Service.Dto.DataProvider;
internal class BaseDtoServiceDataProvider<T>(IBaseService<T> service)
    : IBaseDtoServiceDataProvider<T>
    where T : class, IModel
{
    public Task<T?> GetAsync(long id, ObjectDefinition? definition = null)
        => service.GetAsync(id, definition);

    public Task<T?> GetAsync(string id, ObjectDefinition? definition = null)
        => service.GetAsync(id, definition);

    public Task<IEnumerable<T>?> GetAllAsync(ObjectDefinition? definition = null)
        => service.GetAllAsync(definition);

    public Task<IEnumerable<T>?> GetAllAsync(List<long> ids, ObjectDefinition? definition = null)
        => service.GetAllAsync(ids, definition);

    public Task<IEnumerable<T>?> GetAllByFilterAsync<TFilter>(TFilter filter, ObjectDefinition? definition = null)
        where TFilter : IFilter<T>
        => service.GetAllByFilterAsync(filter, definition);

    public Task<T?> SaveAsync(T item)
        => service.SaveAsync(item);

    public Task<IEnumerable<T>> SaveAsync(List<T> items)
        => service.SaveAsync(items);

    public Task DeleteAsync(T item)
        => service.DeleteAsync(item);
}
