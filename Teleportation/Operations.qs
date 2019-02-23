namespace Quantum.Teleportation
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Math;
	open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Canon;
    
	function testCount() : Int
	{
		return 100;
	}

	operation TeleportSuperposition() : (Double, Double)
	{
		return Teleport(H);
	}

	operation TeleportResult(result: Result) : (Double, Double)
	{
		return Teleport(Set(result, _));
	}

    operation Teleport (prepareStateToSend : (Qubit => Unit)) : (Double, Double) {
		mutable ones = 0;
		using (qubits = Qubit[3])
        {
			let toSend = qubits[2];
			let localEpr = qubits[1];
			let remoteEpr = qubits[0];
			
			for (i in 1..testCount())
			{
				prepareStateToSend(toSend);
				PerformTeleportation(toSend, localEpr, remoteEpr);
			
				if (M(remoteEpr) == One)
				{
					set ones = ones + 1;
				}
			}
			
			ResetAll(qubits);
		}
		let zeroElement = Sqrt((ToDouble(testCount())-ToDouble(ones))/ToDouble(testCount()));
		let oneElement = Sqrt(ToDouble(ones)/ToDouble(testCount()));
		return (zeroElement, oneElement);
    }

	operation PerformTeleportation(toSend: Qubit, localEpr: Qubit, remoteEpr: Qubit) : Unit
	{
		Set(Zero, localEpr);
		Set(Zero, remoteEpr);
		Entangle(remoteEpr, localEpr);
		let (localEprMeasurement, initialStateMeasurement) = GetTeleportInfo(toSend, localEpr);
		DecodeTeleportInfo(localEprMeasurement, initialStateMeasurement, remoteEpr);
	}

	operation Set(desired: Result, q1: Qubit) : Unit
	{    
		let current = M(q1);
		if (desired != current)
		{
			X(q1);
		}
    }

	operation Entangle(q0: Qubit, q1: Qubit) : Unit
	{    
		H(q0);
		CNOT(q0, q1);
    }

	operation GetTeleportInfo(toSend: Qubit, localEpr: Qubit) : (Result, Result)
	{
		CNOT(toSend, localEpr);
		H(toSend);
		return (M(localEpr), M(toSend));
	}

	operation DecodeTeleportInfo(otherEprMeasurement: Result, initialStateMeasurement: Result, targetEpr: Qubit) : Unit
	{
		if (otherEprMeasurement == One)
		{
			X(targetEpr);
		}

		if (initialStateMeasurement == One)
		{
			Z(targetEpr);
		}
	}
}
