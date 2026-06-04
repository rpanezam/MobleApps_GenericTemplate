using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using System.Security.Claims;

namespace AppFactory.Backend.Controllers
{
    [ApiController]
    [Route("api/v1/[controller]")]
    [Authorize]
    [EnableRateLimiting("IpSafeRateLimit")]
    public class UserController : ControllerBase
    {
        [HttpGet("profile")]
        public IActionResult GetProfile()
        {
            // Extract the user identity and claims verified by Firebase JwtBearer Authentication
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            var email = User.FindFirst(ClaimTypes.Email)?.Value;

            if (string.IsNullOrEmpty(userId))
            {
                return Unauthorized(new { Error = "User ID claim not found in authentication token." });
            }

            return Ok(new
            {
                UserId = userId,
                Email = email,
                AuthorizedAt = DateTime.UtcNow,
                Message = "User profile retrieved successfully."
            });
        }
    }
}
