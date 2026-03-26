using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Azure.Cosmos;
using Azure.Identity;

var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults()
    .ConfigureServices(services =>
    {
        // CosmosClient
        services.AddSingleton(serviceprovider =>
        {
            var endpoint =
                Environment.GetEnvironmentVariable("CosmosDb__AccountEndpoint");

            if (string.IsNullOrEmpty(endpoint))
                throw new Exception("Cosmos endpoint is NULL");

            var credential = new DefaultAzureCredential();

            return new CosmosClient(endpoint, credential);
        });

        // Repository
        services.AddSingleton<ICounterRepository, CounterRepository>();

        // Service
        services.AddSingleton<ResumeCounterService>();
    })
    .Build();

host.Run();
