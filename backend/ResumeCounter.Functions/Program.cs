using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Azure.Cosmos;
using Azure.Identity;

var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults()
    .ConfigureServices((context, services) =>
    {
        var config = context.Configuration;

        // CosmosClient (Managed Identity)
        services.AddSingleton(sp =>
        {
            var endpoint = config["CosmosDb__AccountEndpoint"];

            if (string.IsNullOrEmpty(endpoint))
                throw new Exception("CosmosDb__AccountEndpoint is NULL");

            return new CosmosClient(endpoint, new DefaultAzureCredential());
        });

        // Container
        services.AddSingleton(sp =>
        {
            var client = sp.GetRequiredService<CosmosClient>();

            var databaseName = config["CosmosDb__DatabaseName"];
            var containerName = config["CosmosDb__ContainerName"];

            if (string.IsNullOrEmpty(databaseName))
                throw new Exception("CosmosDb__DatabaseName is NULL");

            if (string.IsNullOrEmpty(containerName))
                throw new Exception("CosmosDb__ContainerName is NULL");

            return client.GetContainer(databaseName, containerName);
        });

        // Repository
        services.AddSingleton<ICounterRepository, CounterRepository>();

        // Service
        services.AddSingleton<ResumeCounterService>();
    })
    .Build();

host.Run();
