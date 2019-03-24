namespace Quantum.PhaseEstimation
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	operation ApplyPhaseEstimation(uValues: Result[]) : Result[] {
		return PhaseEstimation(SetToEigenvector(uValues, _), SomeOperation);
	}

	operation SetToEigenvector(values: Result[], qubits: Qubit[]) : Unit {
		for(i in 0..Length(values)-1) {
			Set(values[i], qubits[i]);
		}
	}

	operation SomeOperation(q0: Qubit, q1: Qubit) : Unit {
		body(...){
			Z(q0);
			S(q1);
		}
		controlled auto;
	}
    
    operation PhaseEstimation(SetTo_u: (Qubit[] => Unit),
	                          U: ((Qubit, Qubit) => Unit: Controlled)) : Result[] {
		mutable r0 = Zero;
		mutable r1 = Zero;

		using (qubits = Qubit[4]) {
			H(qubits[0]);
			H(qubits[1]);
			SetTo_u([qubits[2], qubits[3]]);
			Controlled U([qubits[1]], (qubits[2], qubits[3]));
			Controlled Square([qubits[0]], (qubits[2], qubits[3], U));

			Adjoint Fourier2Bit(qubits[0], qubits[1]);

			set r0 = M(qubits[0]);
			set r1 = M(qubits[1]);

			ResetAll(qubits);
		}
		return [r0, r1];
    }
	
	operation Square(q0: Qubit, q1: Qubit, op: ((Qubit, Qubit) => Unit: Controlled)): Unit {
		body(...) {
			op(q0, q1);
			op(q0, q1);
		}
		controlled auto;
	}

	operation Fourier2Bit (q0: Qubit, q1: Qubit) : Unit {
		body (...) {
			H(q0);
			Controlled S([q1], q0);

			H(q1);

			SWAP(q0, q1);
		}
		adjoint auto;
    }

	operation Set(desired: Result, q1: Qubit) : Unit
	{    
		let current = M(q1);
		if (desired != current)
		{
			X(q1);
		}
    }
}
