namespace SeedProject.Host.Controllers
{
    using System.Collections.Generic;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.Extensions.Logging;

    [Route("api/[controller]")]
    [ApiController]
    public class ExampleController : ControllerBase
    {
        private readonly ILogger<ExampleController> logger;

        public ExampleController(ILogger<ExampleController> logger)
        {
            this.logger = logger;
        }

        [HttpGet]
        public ActionResult<IEnumerable<string>> Get()
        {
            this.logger.LogDebug("Invoking the Get all API");

            return new [] { "value1", "value2" };
        }
    }
}
