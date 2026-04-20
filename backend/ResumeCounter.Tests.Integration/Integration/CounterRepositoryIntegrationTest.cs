using Xunit;
using Microsoft.Azure.Cosmos;
using ResumeCounter.Tests.Integration.Fixtures;

namespace ResumeCounter.Tests.Integration;

[Collection("Cosmos collection")]
public class ResumeCounterIntegrationTests
{
    private readonly CosmosFixture _fixture;

    public ResumeCounterIntegrationTests(CosmosFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task IncrementAsync_ShouldIncrementAndPersistCounter()
    {
        var seedCounter = new Counter
        {
            id = "resume",
            Count = 0
        };

        await _fixture.Container.UpsertItemAsync(
            seedCounter,
            new PartitionKey(seedCounter.id));

        var repository = new CounterRepository(_fixture.Container);
        var service = new ResumeCounterService(repository);

        // Act
        var result = await service.IncrementAsync();

        // Assert
        Assert.Equal(1, result);

        var persisted = await _fixture.Container.ReadItemAsync<Counter>(
            "resume",
            new PartitionKey("resume"));

        Assert.Equal(1, persisted.Resource.Count);
    }
}
