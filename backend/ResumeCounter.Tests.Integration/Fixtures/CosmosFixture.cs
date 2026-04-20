using Microsoft.Azure.Cosmos;
namespace ResumeCounter.Tests.Integration.Fixtures;

public class CosmosFixture : IAsyncLifetime
{
    public CosmosClient Client { get; private set; } = null!;
    public Database Database { get; private set; } = null!;
    public Container Container { get; private set; } = null!;
    private readonly string _endpoint;
    private readonly string _key;

    public CosmosFixture()
    {
        _endpoint = Environment.GetEnvironmentVariable("COSMOS_ENDPOINT")
            ?? throw new InvalidOperationException("COSMOS_ENDPOINT not set");

        _key = Environment.GetEnvironmentVariable("COSMOS_KEY")
            ?? throw new InvalidOperationException("COSMOS_KEY not set");
    }

    public async Task InitializeAsync()
    {
        if (string.IsNullOrWhiteSpace(_endpoint))
            throw new InvalidOperationException("COSMOS_ENDPOINT not configured");

        if (string.IsNullOrWhiteSpace(_key))
            throw new InvalidOperationException("COSMOS_KEY not configured");

        Client = new CosmosClient(
            _endpoint,
            _key,
            new CosmosClientOptions
            {
                ConnectionMode = ConnectionMode.Gateway
            });

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