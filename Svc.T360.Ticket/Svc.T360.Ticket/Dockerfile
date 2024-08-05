# Build the runtime image
FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /Svc.T360.Ticket

COPY  bin/Debug/net8.0 /Svc.T360.Ticket

# Expose the port your application will run on
EXPOSE 8080 5198

# Start the application
ENTRYPOINT ["dotnet", "Svc.T360.Ticket.dll"]