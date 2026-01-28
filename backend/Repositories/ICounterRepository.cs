public interface ICounterRepository
{
    Task<Counter> GetCounterAsync();
    Task UpdateCounterAsync(Counter counter);
}