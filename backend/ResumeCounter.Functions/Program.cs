using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Azure.Cosmos;

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

            return new CosmosClient(connectionString); //new CosmosClientOptions
            /*{
                HttpClientFactory = () =>
                {
                    var handler = new HttpClientHandler
                    {
                        ServerCertificateCustomValidationCallback =
                            HttpClientHandler.DangerousAcceptAnyServerCertificateValidator
                    };
                    return new HttpClient(handler);
                }
            });*/
        });

        // Repository
        services.AddSingleton<ICounterRepository, CounterRepository>();

        // Service
        services.AddSingleton<ResumeCounterService>();
    })
    .Build();

host.Run();
