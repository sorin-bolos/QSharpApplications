using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.DeutschJozsa
{
    class Driver
    {
        static void Main(string[] args)
        {
            using (var qsim = new QuantumSimulator())
            {
                Console.WriteLine($"Is Always Zero function invariant? {IsAlwaysZeroInvariant.Run(qsim).Result}");
                Console.WriteLine($"Is Always One function invariant? {IsAlwaysOneInvariant.Run(qsim).Result}");
                Console.WriteLine($"Is One If Odd function invariant? {IsOneIfOddInvariant.Run(qsim).Result}");
            }

            Console.ReadLine();
        }
    }
}