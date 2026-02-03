using Microsoft.Azure.Cosmos;
namespace ResumeCounter.Functions.Repositories;

public class CounterRepositoryIntegrationTests : IAsyncLifetime
{
    private CosmosClient _client = null;
    private Database _database = null;
    private Container _container = null;

    public async Task InitializeAsync()
    {
        _client = new CosmosClient(
            "https://localhost:8081",
            "C2y6yDjf5/R+ob0N8A7Cgv30VRDjEWeZ2R0C4==",
            new CosmosClientOptions
            {
                HttpClientFactory = () =>
                {
                    var handler = new HttpClientHandler
                    {
                        ServerCertificateCustomValidationCallback =
                            HttpClientHandler.DangerousAcceptAnyServerCertificateValidator
                    };
                    return new HttpClient(handler);
                }
            });

            _database = await _client.CreateDatabaseIfNotExistsAsync("IntegrationTestDb");

        _container = await _database.CreateContainerIfNotExistsAsync(
            id: "Counters",
            partitionKeyPath: "/id"
        );
    }

    public async Task DisposeAsync()
    {
        await _database.DeleteAsync();
        _client.Dispose();
    }
}