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

    public async Task<Counter> GetAsync()
    {
        return await _container.ReadItemAsync<Counter>(
            id: "resume",
            partitionKey: new PartitionKey("resume"));
    }

    public async Task UpdateAsync(Counter counter)
    {
        await _container.UpsertItemAsync(
            counter,
            new PartitionKey(counter.id));
    }
}
