using HotChocolate;
using HotChocolate.Resolvers;
using HotChocolate.Types;
using Svc.Extensions.Api.GraphQL.Abstractions;
using Svc.Extensions.Api.GraphQL.HotChocolate;

namespace Svc.T360.Ticket.GraphQL.Queries;

[ExtendObjectType(nameof(Query))]
public class TestQuery
{
    public async Task<GraphQLResponse<string>> GetDateTestAsync(IResolverContext context,
        [Service] IQueryOperation operation)
        => await operation.ExecuteAsync(nameof(GetDateTestAsync),
            async () =>
            {
                var now = DateTime.Now;
                var doy = now.DayOfYear * 100;
                var year = now.Year % 100;
                var dateNo = doy + year;
                var sDateNo = string.Format("{0:D5}", dateNo);

                var hour = ((long)now.Hour * 3600) * 1000;
                var minute = ((long)now.Minute * 60) * 1000;
                var seconds = now.TimeOfDay.Seconds * 1000;
                var milliseconds = now.TimeOfDay.Milliseconds;
                var serialNo = hour;
                serialNo += minute;
                serialNo += seconds;
                serialNo += milliseconds;
                var sSerialNo = string.Format("{0:D8}", serialNo);


                return "";
            });
}
