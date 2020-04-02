// Copyright (c) Sarah Kaiser. All rights reserved.
// Licensed under the MIT License.

namespace Wiqca.Demo {
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

    // Teleportation samples adapted from 
    // https://github.com/microsoft/Quantum/blob/master/samples/getting-started/teleportation/TeleportationSample.qs
    
    /// # Summary
    /// Sends the state of one qubit to a target qubit by using
    /// teleportation.
    ///
    /// Notice that after calling Teleport, the state of `msg` is
    /// collapsed.
    ///
    /// # Input
    /// ## msg
    /// A qubit whose state we wish to send.
    /// ## target
    /// A qubit initially in the |0〉 state that we want to send
    /// the state of msg to.
    operation Teleport (msg : Qubit, target : Qubit) : Unit {
        using (register = Qubit()) {
            // Create some entanglement that we can use to send our message.
            H(register);
            CNOT(register, target);

            // Encode the message into the entangled pair.
            CNOT(msg, register);
            H(msg);

            // Measure the qubits to extract the classical data we need to
            // decode the message by applying the corrections on
            // the target qubit accordingly.
            // We use MResetZ from the Microsoft.Quantum.Measurement namespace
            // to reset our qubits as we go.
            if (MResetZ(msg) == One) { Z(target); }
            // We can also use library functions such as IsResultOne to write
            // out correction steps. This is especially helpful when composing
            // conditionals with other functions and operations, or with partial
            // application.
            if (IsResultOne(MResetZ(register))) { X(target); }
        }
    }

    // One can use quantum teleportation circuit to send an unobserved
    // (unknown) classical message from source qubit to target qubit
    // by sending specific (known) classical information from source
    // to target.

    /// # Summary
    /// Uses teleportation to send a classical message from one qubit
    /// to another.
    ///
    /// # Input
    /// ## message
    /// If `true`, the source qubit (`here`) is prepared in the
    /// |1〉 state, otherwise the source qubit is prepared in |0〉.
    ///
    /// ## Output
    /// The result of a Z-basis measurement on the teleported qubit,
    /// represented as a Bool.
    operation TeleportClassicalMessage (message : Bool) : Bool {
        // Ask for some qubits that we can use to teleport.
        using ((msg, target) = (Qubit(), Qubit())) {

            // Encode the message we want to send.
            if (message) {
                X(msg);
            }

            // Use the operation we defined above.
            Teleport(msg, target);

            // Check what message was sent.
            return MResetZ(target) == One;
        }
    }

    // One can also use quantum teleportation to send any quantum state
    // without losing any information. The following sample shows
    // how a randomly picked non-trivial state (|-> or |+>)
    // gets moved from one qubit to another.


}
 