using Svc.Extensions.AWS.Abstractions;
using Svc.Extensions.Db.Data.Abstractions.Core;

namespace Svc.T360.Ticket.Data.TokenProvider;
internal class DbTokenProvider(IAmazonRdsAuthTokenGenerator tokenGenerator) : IDbTokenProvider
{
    public bool IsEnabled => true;

    public Task<string> GetTokenAsync(string host, int port, string username)
        => Task.FromResult(tokenGenerator.GenerateAuthToken(host, port, username));
}
