using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Configuration;

var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults()
    .ConfigureServices((context, services) =>
    {
        var config = context.Configuration;

        // CosmosClient (Managed Identity)
        services.AddSingleton(sp =>
        {
            var config = sp.GetRequiredService<IConfiguration>();
            var connectionString = config["CosmosDb__ConnectionString"];
        
            if (string.IsNullOrWhiteSpace(connectionString))
                throw new Exception("CosmosDb__ConnectionString is missing");
        
            return new CosmosClient(connectionString);
        });

        // Container
        services.AddSingleton(sp =>
        {
            var client = sp.GetRequiredService<CosmosClient>();
            var config = sp.GetRequiredService<IConfiguration>();
        
            return client
                .GetDatabase(config["CosmosDb__DatabaseName"])
                .GetContainer(config["CosmosDb__ContainerName"]);
        });

        // Repository
        services.AddSingleton<ICounterRepository, CounterRepository>();

        // Service
        services.AddSingleton<ResumeCounterService>();
    })
    .Build();

host.Run();
