using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.QuantumFourier3Bits
{
    class Driver
    {
        private const int NumberOfTests = 10;
        private const int NumberOfMeasurementsPerTest = 100;

        static void Main(string[] args)
        {
            Console.Write("Enter a number to transform: ");
            string input = Console.ReadLine();

            if (!int.TryParse(input, out int number) || number < 0 || number > 7)
            {
                Console.WriteLine("Number must be between 0 and 7");
                Console.ReadKey();
                return;
            }

            var binary = ConvertToBase2(number);
            Console.WriteLine($"Applying Fourier transform to {binary[0]}{binary[1]}{binary[2]}");
            for (int i = 0; i < 4; i++)
            {
                var measurementBasis = (Pauli)i;
                Console.WriteLine($"Measuring {measurementBasis}");
                var results = PerformTests(binary, measurementBasis);
                foreach (var key in results.Keys)
                {
                    var finalAsBinary = ConvertToBase2(key);
                    Console.WriteLine($"Fourier transform returned {key} ({finalAsBinary[0]}{finalAsBinary[1]}{finalAsBinary[2]}) - {results[key]}%");
                }
            }
            Console.WriteLine("Finished");
            Console.ReadKey();
        }

        static Dictionary<int, double> PerformTests(int[] binary, Pauli pauli)
        {
            var results = new Dictionary<int, double>();
            for (int i = 0; i < NumberOfTests; i++)
            {
                var testResults = PerformTest(binary, pauli);
                foreach (var result in testResults.Keys)
                {
                    if (!results.ContainsKey(result))
                        results[result] = 0;
                    results[result] += testResults[result] / (double)NumberOfTests;
                }
            }
            return results;
        }

        static Dictionary<int, double> PerformTest(int[] binary, Pauli pauli)
        {
            var results = new Dictionary<int, double>();
            for (int i = 0; i < NumberOfMeasurementsPerTest; i++)
            {
                var result = PerformTransform(binary, pauli);

                if (!results.ContainsKey(result))
                    results[result] = 0;
                results[result] += 100.00 / (double)NumberOfMeasurementsPerTest;
            }
            return results;
        }

        static int PerformTransform(int[] binary, Pauli pauli)
        {
            using (var qsim = new QuantumSimulator())
            {
                var inputAsResults = new QArray<Result>(binary.Cast<Result>());
                var resultAsBinary = Fourier.Run(qsim, inputAsResults, pauli).Result.Cast<int>().ToArray();
                var result = ConvertToBase10(resultAsBinary);
                return result;
            }
        }

        static int[] ConvertToBase2(int number)
        {
            var result = new int[3];
            int index = 2;
            while(number > 0)
            {
                result[index] = number % 2;
                number = number / 2;
                index--;
            }

            return result;
        }

        static int ConvertToBase10(int[] bits)
        {
            var result = 0;
            for(int i = 0; i < bits.Length; i++)
            {
                result +=  (int)Math.Pow(2,(bits.Length - 1 - i)) * bits[i];
            }
            return result;
        }
    }
}