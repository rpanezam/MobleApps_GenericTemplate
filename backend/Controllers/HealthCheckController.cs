using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace AppFactory.Backend.Controllers
{
    [ApiController]
    [Route("api/v1/[controller]")]
    [EnableRateLimiting("IpSafeRateLimit")]
    public class HealthCheckController : ControllerBase
    {
        [HttpGet]
        public IActionResult Get()
        {
            return Ok(new
            {
                Status = "Healthy",
                Timestamp = DateTime.UtcNow,
                Message = "App Factory Unified Backend Service is fully operational."
            });
        }
    }
}
