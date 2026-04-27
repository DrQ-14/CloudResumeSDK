using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Configuration;
using Azure.Identity;

var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults()
    .ConfigureServices(services =>
    {
        // Cosmos client
        services.AddSingleton(s =>
        {
            var config = s.GetRequiredService<IConfiguration>();

            var endpoint = config["CosmosDb:AccountEndpoint"];

            return new CosmosClient(endpoint, new DefaultAzureCredential());
        });

        // Container
        services.AddSingleton(serviceProvider =>
        {
            var client = serviceProvider.GetRequiredService<CosmosClient>();

            return client
                .GetDatabase("resume-db")
                .GetContainer("counter");
        });

        // Repository
        services.AddSingleton<ICounterRepository, CounterRepository>();

        // Service
        services.AddSingleton<ResumeCounterService>();
    })
    .Build();

host.Run();