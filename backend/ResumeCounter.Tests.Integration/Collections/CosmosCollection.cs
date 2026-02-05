// CosmosCollection.cs
using Xunit;
using ResumeCounter.Tests.Integration.Fixtures;
namespace ResumeCounter.Tests.Integration.Fixtures;

[CollectionDefinition("Cosmos collection")]
public class CosmosCollection : ICollectionFixture<CosmosFixture>
{
    // no code here — this just binds the name to the fixture
}
