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
            _endpoint,
            new DefaultAzureCredential()
        );

        Database = Client.GetDatabase("app-db");
        Container = Database.GetContainer("counters");
    }

    public async Task ResetContainerAsync()
    {
        var iterator = Container.GetItemQueryIterator<dynamic>("SELECT * FROM c");
    
        while (iterator.HasMoreResults)
        {
            foreach (var item in await iterator.ReadNextAsync())
            {
                await Container.DeleteItemAsync<dynamic>(
                    item.id.ToString(),
                    new PartitionKey(item.id.ToString())
                );
            }
        }
    }

    public Task DisposeAsync()
    {
        Client?.Dispose();
        return Task.CompletedTask;
    }
}