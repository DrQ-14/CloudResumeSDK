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
    }

    public async Task InitializeAsync()
    {
        Client = new CosmosClient(
            accountEndpoint: _endpoint,
            tokenCredential: new DefaultAzureCredential()
        );

        Database = await Client.CreateDatabaseIfNotExistsAsync("IntegrationTestDb");

        Container = await Database.CreateContainerIfNotExistsAsync(
            id: "Counters",
            partitionKeyPath: "/id"
        );
    }

    public async Task ResetContainerAsync()
    {
        await Container.DeleteContainerAsync();

        Container = await Database.CreateContainerIfNotExistsAsync(
            id: "Counters",
            partitionKeyPath: "/id"
        );
    }

    public async Task DisposeAsync()
    {
        if (Database != null)
        {
            await Database.DeleteAsync();
        }

        Client?.Dispose();
    }
}