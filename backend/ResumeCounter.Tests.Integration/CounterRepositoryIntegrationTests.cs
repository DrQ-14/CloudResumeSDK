using Microsoft.Azure.Cosmos;
using Xunit;
using ResumeCounter.Tests.Integration.Fixtures;

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
            Id = Guid.NewGuid().ToString(),
            Count = 1
        };

        // Act
        await _fixture.Container.CreateItemAsync(counter, new PartitionKey(counter.Id));

        var response = await _fixture.Container.ReadItemAsync<Counter>(
            counter.Id,
            new PartitionKey(counter.Id));

        // Assert
        Assert.Equal(1, response.Resource.Count);
    }
}
