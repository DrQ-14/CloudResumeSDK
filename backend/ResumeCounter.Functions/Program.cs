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

            return new CosmosClient(endpoint, new DefaultAzureCredential());
        });

        // Container
        services.AddSingleton(sp =>
        {
            var client = sp.GetRequiredService<CosmosClient>();

            var database= config["CosmosDb__Database"];
            var container = config["CosmosDb__Container"];

            return client.GetContainer(database, container);
        });

        // Repository
        services.AddSingleton<ICounterRepository, CounterRepository>();

        // Service
        services.AddSingleton<ResumeCounterService>();
    })
    .Build();

host.Run();
