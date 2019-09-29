using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace TimeServer.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CoopController : ControllerBase
    {
        public static List<Chicken> ChickenCoop { get; set; } = new List<Chicken>();

        public CoopController()
        {
            if (!ChickenCoop.Any())
            {
                ChickenCoop.Add(new Chicken(Gender.Male, 1, "Rex"));
                ChickenCoop.Add(new Chicken(Gender.Female, 1, "Francine"));
            }
        }

        //lists all chickens in the coop
        [HttpGet]
        public ActionResult Get()
        {
            return Ok(ChickenCoop);
        }

        //adds a chicken to the coop
        [HttpPost]
        public ActionResult Post(Chicken chicken)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest("Invalid chicken.");
            }
            ChickenCoop.Add(chicken);
            //ChickenCoop.Add(JsonConvert.DeserializeObject<Chicken>(chicken));
            return Ok();
        }

        //removes a chicken from the coop
        [HttpDelete]
        public ActionResult Delete(Chicken chicken)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest("Invlaid Model");
            }
            if (!ChickenCoop.Any(x => x.ID == chicken.ID))
            {
                return BadRequest("Chicken not found.");
            }
            else
            {
                ChickenCoop.Remove(chicken);
            }
            return Ok();
        }

        //updates a chicken's information
        [HttpPut]
        public ActionResult Put(Chicken chicken)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest("Invalid chicken.");
            }
            if (!ChickenCoop.Any(x=>x.ID == chicken.ID))
            {
                return BadRequest("Chicken not found.");
            }
            var chickenToUpdate = ChickenCoop.Single(x => x.ID.ToString().Equals(chicken.ID.ToString()));
          
            chickenToUpdate.Name = chicken.Name;
            chickenToUpdate.Age = chicken.Age;
            chickenToUpdate.Gender = chicken.Gender;
            return Ok();
        }
    }
}
