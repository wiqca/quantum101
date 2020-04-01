// Copyright (c) Sarah Kaiser. All rights reserved.
// Licensed under the MIT License.

namespace PyLadies.Demo {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;

    /// # Summary
    /// Prints out the standard "Hello, world!" message with a
    /// bonus favorite number passed as input.
    ///
    /// # Description
    /// Takes an `Int` as input and prints the standard test message 
    /// as well as what integer the user likes.
    ///
    /// # Input
    /// ## FavoriteNumber
    /// The integer you think is the coolest.
    function HelloWorld (favoriteNumber : Int) : Unit {
        Message($"Hello, world! I like the number {favoriteNumber}.");
    }

    /// # Summary
    /// Generates a random value from {0,1} by measuring a qubit in 
    /// an equal superposition.
    ///
    /// # Description
    /// Given a qubit initially in the |0⟩ state, applies the H operation
    /// to that qubit such that it has the state (1/√2) |0⟩ + (1/√2) |1⟩.
    /// Measurement of this state returns a One Result with probability 0.5
    /// and a Zero Result with probability 0.5. 
    operation Qrng() : Result {
        using (qubit = Qubit()) {

            H(qubit);

            return MResetZ(qubit);
        }
    }

    /// # Summary
    /// Generates a random value from {0,1} by measuring a qubit in 
    /// an equal superposition, and show some diagnostics of the 
    /// target machine.
    ///
    /// # Description
    /// Given a qubit initially in the |0⟩ state, applies the H operation
    /// to that qubit such that it has the state (1/√2) |0⟩ + (1/√2) |1⟩.
    /// Measurement of this state returns a One Result with probability 0.5
    /// and a Zero Result with probability 0.5. 
    operation QrngWithDiagnostics() : Result {
        using (qubit = Qubit()) {
            
            Message("Here is what the simulator uses to record a qubit in the 0 state:");
            DumpRegister((), [qubit]);
            Message(" ");

            H(qubit);

            Message("After using H(qubit) to create a superposition state:");
            DumpRegister((), [qubit]);
 
            return MResetZ(qubit);
        }
    }

    /// # Summary
    /// Generates a pair of entangled qubits and then measures them.
    ///
    /// # Description
    /// Given two qubits initially in the |0⟩ state, applies the H operation
    /// to qubit 1 such that it has the state (1/√2) |0⟩ + (1/√2) |1⟩.
    /// Then qubit 1 is used as the control for a CNOT operation on qubit 2.
    /// Measurement of this state returns a (0,0) Result with probability 0.5
    /// and a (1,1) Result with probability 0.5. 
    operation EntangleQubits(verbose : Bool) : (Result, Result) {
        // Preparing two qubits
        using ((qubit1, qubit2) = (Qubit(), Qubit())) {

            if (verbose) {
                Message("State of inital two qubits:");
                DumpRegister((), [qubit1, qubit2]);
            }
            // The operations on the qubits needed to entangle them
            H(qubit1);
            CNOT(qubit1, qubit2);

            if (verbose) {
                Message(" ");
                Message("After entangling the two qubits:");
                DumpRegister((), [qubit1, qubit2]);
            }
            // Finally, measure and reset the qubits
            return (MResetZ(qubit1), MResetZ(qubit2));
        }
    }
}
 