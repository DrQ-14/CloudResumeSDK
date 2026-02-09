using Microsoft.Azure.Cosmos;
using Xunit;
using ResumeCounter.Tests.Integration.Fixtures;
using System.Diagnostics.Metrics;

namespace ResumeCounter.Tests.Integration;

[Collection("Cosmos collection")]
public class CosmosFixtureSmokeTests
{
    private readonly CosmosFixture _fixture;

    public CosmosFixtureSmokeTests(CosmosFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task Can_write_and_read_item_from_container()
    {
        // Arrange
        await _fixture.ResetContainerAsync();

        var counter = new Counter
        {
            id = Guid.NewGuid().ToString(),
            Count = 1
        };

        // Act
        await _fixture.Container.CreateItemAsync(counter, new PartitionKey(counter.id));

        var response = await _fixture.Container.ReadItemAsync<Counter>(
            counter.id,
            new PartitionKey(counter.id));

        // Assert
        Assert.Equal(1, response.Resource.Count);
    }
}
