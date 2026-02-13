using Microsoft.Azure.Cosmos;
namespace ResumeCounter.Tests.Integration.Fixtures;

public class CosmosFixture : IAsyncLifetime
{
    public CosmosClient Client { get; private set; } = null!;
    public Database Database { get; private set; } = null!;
    public Container Container { get; private set; } = null!;

    private async Task<bool> IsEmulatorReachableAsync()
    {
        try
        {
            var handler = new HttpClientHandler
        {
            ServerCertificateCustomValidationCallback =
                HttpClientHandler.DangerousAcceptAnyServerCertificateValidator
        };

        using var client = new HttpClient(handler)
        {
            Timeout = TimeSpan.FromSeconds(2)
        };

        // Use a guaranteed endpoint
        var response = await client.GetAsync("https://localhost:8081/_explorer/emulator.pem");
        return response.IsSuccessStatusCode;
        }
        catch
        {
            return false;
        }
    }


    public async Task InitializeAsync()
    {
        if (!await IsEmulatorReachableAsync())
        {
            throw new InvalidOperationException(
                "Cosmos emulator is not running. Start the emulator before running integration tests."
            );
        }

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