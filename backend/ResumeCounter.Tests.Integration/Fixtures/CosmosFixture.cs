using Microsoft.Azure.Cosmos;
namespace ResumeCounter.Tests.Integration.Fixtures;

public class CosmosFixture : IAsyncLifetime
{
public CosmosClient Client { get; private set; } = null!;
public Database Database { get; private set; } = null!;
public Container Container { get; private set; } = null!;
    
    public async Task InitializeAsync()
    {
        Client = new CosmosClient(
            "https://localhost:8081",
            "C2y6yDjf5/R+ob0N8A7Cgv30VRDJIWEHLM+4QDU5DE2nQ9nDuVTqobD4b8mGGyPMbIZnqyMsEcaGQy67XIw/Jw==",
            new CosmosClientOptions
            {
                ConnectionMode = ConnectionMode.Gateway,
                HttpClientFactory = () =>
                {
                    var handler = new HttpClientHandler
                    {
                        ServerCertificateCustomValidationCallback =
                            HttpClientHandler.DangerousAcceptAnyServerCertificateValidator
                    };
                    return new HttpClient(handler);
                },
                LimitToEndpoint = true
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