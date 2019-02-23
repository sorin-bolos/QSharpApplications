using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.Deutsch
{
    class Driver
    {
        static void Main(string[] args)
        {
            using (var qsim = new QuantumSimulator())
            {
                Console.WriteLine($"Is identity function invariant? {IsIdentityInvariant.Run(qsim).Result}");
                Console.WriteLine($"Is negation function invariant? {IsNegationInvariant.Run(qsim).Result}");
                Console.WriteLine($"Is set to zero function invariant? {IsSetToZeroInvariant.Run(qsim).Result}");
                Console.WriteLine($"Is set to one function invariant? {IsSetToOneInvariant.Run(qsim).Result}");
            }

            Console.ReadLine();
        }
    }
}