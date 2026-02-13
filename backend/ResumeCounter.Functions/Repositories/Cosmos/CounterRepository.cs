using Microsoft.Azure.Cosmos;

public class CounterRepository : ICounterRepository
{
    private readonly Container _container;

    public CounterRepository(CosmosClient client)
    {
        var databaseName =
            Environment.GetEnvironmentVariable("CosmosDb__Database");
        var containerName =
            Environment.GetEnvironmentVariable("CosmosDb__Container");

        _container = client.GetContainer(databaseName, containerName);
    }

    public async Task<Counter> GetCounterAsync()
    {
        var response = await _container.ReadItemAsync<Counter>(
        id: "resume",
        partitionKey: new PartitionKey("resume"));

    return response.Resource;
    }

    public async Task UpdateCounterAsync(Counter counter)
    {
        await _container.UpsertItemAsync(
            counter,
            new PartitionKey(counter.id));
    }
}
