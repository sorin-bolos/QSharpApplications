using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.Teleportation
{
    class Driver
    {
        static void Main(string[] args)
        {
            int numberOfTests = 10;
            using (var qsim = new QuantumSimulator())
            {
                var oneProbabilities = new List<double>();
                var zeroProbabilities = new List<double>();
                for (int i = 0; i < numberOfTests; i++)
                {
                    var (zeroProbability, oneProbability) = TeleportResult.Run(qsim, Result.Zero).Result;
                    zeroProbabilities.Add(zeroProbability);
                    oneProbabilities.Add(oneProbability);

                }
                Console.WriteLine($"[{zeroProbabilities.Average()}, {oneProbabilities.Average()}]");
            }
            Console.ReadLine();
        }
    }
}