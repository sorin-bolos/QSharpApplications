using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.SuperdenseCoding
{
    class Driver
    {
        static void Main(string[] args)
        {
            using (var qsim = new QuantumSimulator())
            {
                var (received1, received2) = SuperDenseCoding.Run(qsim, false, false).Result;
                Console.WriteLine($"Sent false false - received {received1} {received2}");

                (received1, received2) = SuperDenseCoding.Run(qsim, false, true).Result;
                Console.WriteLine($"Sent false true - received {received1} {received2}");

                (received1, received2) = SuperDenseCoding.Run(qsim, true, false).Result;
                Console.WriteLine($"Sent true false - received {received1} {received2}");

                (received1, received2) = SuperDenseCoding.Run(qsim, true, true).Result;
                Console.WriteLine($"Sent true true - received {received1} {received2}");
            }
            Console.ReadLine();
        }
    }
}