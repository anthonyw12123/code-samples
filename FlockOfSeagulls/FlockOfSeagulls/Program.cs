using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace FlockOfSeagulls
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("There is a flock of seagulls. Press any key to approach them.");
            Console.ReadKey();
            var seagulls = from i in Enumerable.Range(1, 20)
                           select BeASeagull(i);
            List<Task> flock = seagulls.ToList();
            Task t = Task.WhenAll(flock);
            try
            {
                t.Wait();
                Console.WriteLine("They're all gone...");
            }
            catch (Exception ex)
            {
                Console.WriteLine("there were issues handling the flock.");
            }
        }

        static async Task BeASeagull(int i)
        {
            Random rand = new Random(Guid.NewGuid().ToByteArray().Sum(x=>x));
            int timeToTalk = rand.Next(10000,15000);
            var timeFinished = await Task.Run(() =>
            {
                var finished = false;
                while (timeToTalk > 0)
                {
                    Console.WriteLine($"{i}: Mine!");
                    int timeToSleep = rand.Next(300,2000);
                    timeToTalk -= timeToSleep;
                    Task t = Task.Delay(timeToSleep);
                    t.Wait();
                }
                finished = true;
                return finished;
            });
            Console.WriteLine($"...and this seagull ({i}) flies away.");
            
        }
    }
}
