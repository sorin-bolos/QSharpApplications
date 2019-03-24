namespace Quantum.QuantumFourier3Bits
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    
	operation Fourier(bits: Result[], measurementBasis: Pauli) : Result[] {
		let len = Length(bits);
		mutable result = new Result[0];

		if (len <= 0 || len > 3)
		{
			Message("You must supply a number encoded in 1, 2, or 3 bits");
			return result;
		}

		using(qubits = Qubit[len]) {
			
			for(i in 0..len-1) {
				Set(bits[i], qubits[i]);
			}

			if (len == 1) {
				Fourier1Bit(qubits[0]);
				set result = [Measure([measurementBasis], [qubits[0]])];
			}
			else {
				if (len == 2) {
					Fourier2Bit(qubits[0], qubits[1]);
					set result = [Measure([measurementBasis], [qubits[0]]),
					              Measure([measurementBasis], [qubits[1]])];
				}
				else {
					Fourier3Bit(qubits[0], qubits[1], qubits[2]);
					set result = [Measure([measurementBasis], [qubits[0]]),
					              Measure([measurementBasis], [qubits[1]]),
								  Measure([measurementBasis], [qubits[2]])];
				}
			}

			ResetAll(qubits);
		}
		return result;
	}

    operation Fourier1Bit (q0: Qubit) : Unit {
        body (...) {
			H(q0);
		}
		adjoint auto;
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
