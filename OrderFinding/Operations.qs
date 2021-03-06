﻿namespace Quantum.OrderFinding
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	operation ApplyOrderFinding(uValues: Result[]) : Result[] {
		return OrderFinding(SetToEigenvector(uValues, _), Times3Modulo4);
	}

	operation SetToEigenvector(values: Result[], qubits: Qubit[]) : Unit {
		for(i in 0..Length(values)-1) {
			Set(values[i], qubits[i]);
		}
	}

	operation Times3Modulo4(q0: Qubit, q1: Qubit) : Unit {
		body(...){
			CNOT(q1, q0);
		}
		controlled auto;
	}
    
    operation OrderFinding(SetTo_u: (Qubit[] => Unit),
	                          U: ((Qubit, Qubit) => Unit: Controlled)) : Result[] {
		mutable r0 = Zero;
		mutable r1 = Zero;
		mutable r2 = Zero;

		using (qubits = Qubit[5]) {
			H(qubits[0]);
			H(qubits[1]);
			H(qubits[2]);
			SetTo_u([qubits[3], qubits[4]]);
			Controlled U([qubits[2]], (qubits[3], qubits[4]));
			Controlled Square([qubits[1]], (qubits[3], qubits[4], U));
			Controlled ToTheForth([qubits[0]], (qubits[3], qubits[4], U));

			Adjoint Fourier3Bit(qubits[0], qubits[1], qubits[2]);

			set r0 = M(qubits[0]);
			set r1 = M(qubits[1]);
			set r2 = M(qubits[2]);

			ResetAll(qubits);
		}
		return [r0, r1, r2];
    }
	
	operation Square(q0: Qubit, q1: Qubit, op: ((Qubit, Qubit) => Unit: Controlled)): Unit {
		body(...) {
			op(q0, q1);
			op(q0, q1);
		}
		controlled auto;
	}

	operation ToTheForth(q0: Qubit, q1: Qubit, op: ((Qubit, Qubit) => Unit: Controlled)): Unit {
		body(...) {
			op(q0, q1);
			op(q0, q1);
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

	operation Fourier3Bit (q0: Qubit, q1: Qubit, q2: Qubit) : Unit {
		body (...) {
			H(q0);
			Controlled S([q1], q0);
			Controlled T([q2], q0);

			H(q1);
			Controlled S([q2], q1);

			H(q2);

			SWAP(q0, q2);
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
