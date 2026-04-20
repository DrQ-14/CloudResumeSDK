using Microsoft.Azure.Cosmos;

public class CounterRepository : ICounterRepository
{
    private readonly Container _container;

    public CounterRepository(Container container)
    {
        _container = container;
    }

    public async Task<Counter> GetCounterAsync()
    {
        try
        {
            var response = await _container.ReadItemAsync<Counter>(
                id: "resume",
                partitionKey: new PartitionKey("resume"));
            return response.Resource;
        }
        catch (CosmosException ex) when (ex.StatusCode == System.Net.HttpStatusCode.NotFound)
        {
            var counter = new Counter { id = "resume", Count = 0 };
            await _container.CreateItemAsync(counter, new PartitionKey(counter.id));
            return counter;
        }
    }

    public async Task UpdateCounterAsync(Counter counter)
    {
        await _container.UpsertItemAsync(
            counter,
            new PartitionKey(counter.id));
    }
}
