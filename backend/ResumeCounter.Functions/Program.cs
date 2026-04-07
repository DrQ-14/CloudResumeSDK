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
            var connectionString =
                Environment.GetEnvironmentVariable("CosmosDb__ConnectionString");

            if (string.IsNullOrEmpty(connectionString))
                throw new Exception("Cosmos connection string is NULL");

            return new CosmosClient(connectionString);
        });

        // Repository
        services.AddSingleton<ICounterRepository, CounterRepository>();

        // Service
        services.AddSingleton<ResumeCounterService>();
    })
    .Build();

host.Run();
