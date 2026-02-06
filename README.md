# optoML_single_stage_pipeline_register
This repo is made for task assigned by optoML for the role of ASIC/RTL Design Intern.

**TASK**: Implement a single-stage pipeline register in SystemVerilog using a standard valid/ready handshake. 

**LOGIC**: The module sits between an input and output interface, accepts data when in_valid and in_ready are asserted, presents stored data on the output with out_valid, 
and correctly handles backpressure without data loss or duplication. The design should be fully synthesizable and reset to a clean, empty state. 


**task_optoML** is a synthesized SystemVerilog implementation of a robust, single-stage pipeline register. It implements a standard **Valid/Ready Handshake** protocol (similar to AXI4-Stream) to facilitate reliable data transfer between digital processing stages.

This module is designed to break timing paths on the `valid` and `data` signals while correctly handling backpressure (flow control) without data loss or duplication.

## Output Waveform
<img width="1880" height="527" alt="output_waveform" src="https://github.com/user-attachments/assets/bea80eac-46de-48b2-9990-347daf53b5e7" />


## 🚀 Key Features

* **Protocol Compliance:** Standard Valid/Ready handshake logic.
* **Backpressure Handling:** Automatically stalls and holds data when the downstream module is busy (`i_ready` is low).
* **Zero-Bubble Forwarding:** Capable of 100% throughput (1 transaction per clock) when downstream is ready.
* **Clean Reset:** Synchronous reset logic ensures a known empty state upon startup.
* **Synthesizable:** Written in standard SystemVerilog, compatible with FPGA and ASIC workflows.

## 🛠️ Architecture

The design uses a **Forward Registered / Backward Combinational** architecture.
* **Data Path:** The `data` and `valid` signals are registered (flip-flops) to break the forward timing path.
* **Control Path:** The upstream ready signal (`o_ready`) is generated combinatorially to allow immediate response to downstream backpressure.

**Logic Core:**
```systemverilog
// We accept new data if:
// 1. The downstream stage is ready to take our current data (i_ready == 1)
// 2. OR, we are currently empty/invalid (~valid_register)
assign o_ready = i_ready | ~valid_register;


