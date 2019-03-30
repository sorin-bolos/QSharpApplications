using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.PhaseEstimation
{
    class Driver
    {
        private const int NumberOfTests = 10;
        private const int NumberOfMeasurementsPerTest = 100;

        static void Main(string[] args)
        {
            for (int i = 0; i < 4; i++)
            {
                int[] uValues = ConvertToBase2(i);
                Console.WriteLine($"Estimating phase for vector {string.Join("", uValues)}");
                var results = PerformTests(uValues);
                foreach (var key in results.Keys)
                {
                    Console.WriteLine($"Phase estimation returned 0.{key} - {results[key]}%");
                }
            }

            Console.WriteLine("Finished");
            Console.ReadLine();
        }

        static Dictionary<string, double> PerformTests(int[] uValues)
        {
            var results = new Dictionary<string, double>();
            for (int i = 0; i < NumberOfTests; i++)
            {
                var testResults = PerformTest(uValues);
                foreach (var result in testResults.Keys)
                {
                    if (!results.ContainsKey(result))
                        results[result] = 0;
                    results[result] += testResults[result] / (double)NumberOfTests;
                }
            }
            return results;
        }

        static Dictionary<string, double> PerformTest(int[] uValues)
        {
            var results = new Dictionary<string, double>();
            for (int i = 0; i < NumberOfMeasurementsPerTest; i++)
            {
                var result = PerformEstimation(uValues);

                if (!results.ContainsKey(result))
                    results[result] = 0;
                results[result] += 100.00 / (double)NumberOfMeasurementsPerTest;
            }
            return results;
        }

        static string PerformEstimation(int[] uValues)
        {
            using (var qsim = new QuantumSimulator())
            {
                var phase = ApplyPhaseEstimation.Run(qsim, new QArray<Result>(uValues.Cast<Result>()))
                                                        .Result
                                                        .Cast<int>()
                                                        .ToArray();
                return string.Join("", phase);
            }
        }

        static int[] ConvertToBase2(int number)
        {
            var result = new int[2];
            int index = 1;
            while (number > 0)
            {
                result[index] = number % 2;
                number = number / 2;
                index--;
            }

            return result;
        }
    }
}