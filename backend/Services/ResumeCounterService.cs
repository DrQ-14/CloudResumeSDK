using System.Diagnostics.Metrics;

public class ResumeCounterService
{
    private readonly ICounterRepository _repo;

    public ResumeCounterService(ICounterRepository repo)
    {
        _repo = repo;
    }

    public async Task<int> IncrementAsync()
    {
        var counter = await _repo.GetCounterAsync();
        counter.Count++;
        await _repo.UpdateCounterAsync(counter);
        return counter.Count;   
    }
}