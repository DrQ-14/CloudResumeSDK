using Microsoft.Azure.Cosmos;
using Azure.Identity;
namespace ResumeCounter.Tests.Integration.Fixtures;

public class CosmosFixture : IAsyncLifetime
{
    public CosmosClient Client { get; private set; } = null!;
    public Database Database { get; private set; } = null!;
    public Container Container { get; private set; } = null!;
    private readonly string _endpoint;

    public CosmosFixture()
    {
        _endpoint = Environment.GetEnvironmentVariable("COSMOS_ENDPOINT")
            ?? throw new InvalidOperationException("COSMOS_ENDPOINT not set");

        _databaseName = Environment.GetEnvironmentVariable("COSMOS_DB_NAME")
            ?? throw new InvalidOperationException("COSMOS_DB_NAME not set");

        _containerName = Environment.GetEnvironmentVariable("COSMOS_CONTAINER")
            ?? throw new InvalidOperationException("COSMOS_CONTAINER not set");
    }

    public async Task InitializeAsync()
    {
        Client = new CosmosClient(
            _endpoint,
            new DefaultAzureCredential()
        );

        Database = Client.GetDatabase("app-db");
        Container = Database.GetContainer("counters");
    }

    public Task DisposeAsync()
    {
        Client?.Dispose();
        return Task.CompletedTask;
    }
}