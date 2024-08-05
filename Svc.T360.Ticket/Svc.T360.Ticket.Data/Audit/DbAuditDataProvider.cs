using Audit.Core;

namespace Svc.T360.Ticket.Data.Audit;
internal class DbAuditDataProvider : AuditDataProvider
{
    public override async Task<object> InsertEventAsync(AuditEvent auditEvent,
        CancellationToken cancellationToken = default)
    {
        throw new NotImplementedException();
    }

    public override object InsertEvent(AuditEvent auditEvent)
    {
        throw new NotImplementedException();
    }
}
