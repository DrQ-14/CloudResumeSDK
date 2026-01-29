using Moq;
using Xunit;
using System.Threading.Tasks;
namespace ResumeCounter.Tests;

public class UnitTest1
{
    [Fact]
    public async Task IncrementAsync_ShouldIncrementCounterAndReturnNewValue()
    {
        // Arrange
        var mockRepo = new Mock<ICounterRepository>();

        var initialCounter = new Counter { Count = 5 };

        // Setup GetCounterAsync to return initialCounter
        mockRepo.Setup(repo => repo.GetCounterAsync())
                .ReturnsAsync(initialCounter);

        // Setup UpdateCounterAsync to just return completed task
        mockRepo.Setup(repo => repo.UpdateCounterAsync(It.IsAny<Counter>()))
                .Returns(Task.CompletedTask);

        var service = new ResumeCounterService(mockRepo.Object);

        // Act
        var newCount = await service.IncrementAsync();

        // Assert
        Assert.Equal(6, newCount);

        // Verify that GetCounterAsync was called once
        mockRepo.Verify(repo => repo.GetCounterAsync(), Times.Once);

        // Verify that UpdateCounterAsync was called once with the counter's count incremented
        mockRepo.Verify(repo => repo.UpdateCounterAsync(It.Is<Counter>(c => c.Count == 6)), Times.Once);
    }
}