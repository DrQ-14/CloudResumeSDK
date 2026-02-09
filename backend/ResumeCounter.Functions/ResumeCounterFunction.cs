using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using System.Net;

public class ResumeCounterFunction
{
    private readonly ResumeCounterService _service;

    public ResumeCounterFunction(ResumeCounterService service)
    {
        _service = service;
    }

    [Function("ResumeCounter")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
    {
        var count = await _service.IncrementAsync();

        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteAsJsonAsync(new { count });

        return response;
    }
}
