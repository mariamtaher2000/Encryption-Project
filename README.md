# **Lightweight Cryptography** 
The era of the Internet of Things (IoT) introduces new technologies alongside challenges in hardware and data transfer security. This work presents the hardware implementation of the Lightweight Cryptography (LWC) algorithm Ascon-128, using systemverilog, specifically targeting IoT applications and small devices with power and area constraints. The proposed design requires fewer logic gates by employing serialized hardware architecture, resulting in a compact area and low power consumption at 13.7 MHz, a frequency commonly used in Radio-Frequency Identification (RFID). 
Simultaneously, it maintains adequate throughput by minimizing latency per round using a sponge-based construction in authenticated mode. The hardware implementation is demonstrated on a Field-Programmable Gate Array (FPGA) platform, specifically targeting low-power kits to emulate resource-constrained IoT environments. 
Moreover, the Application-Specific Integrated Circuit (ASIC) implementation of Ascon-128 using 16nm TSMC technology demonstrates a cutting-edge advancement for IoT applications, offering promising potential for future deployment with FinFET technology.

<img width="890" alt="1" src="https://github.com/user-attachments/assets/0a34d2a9-37cb-4425-8e8d-6ee06da969c2" />

**Proposed Ascon Core Architecture**

<img width="1074" alt="4" src="https://github.com/user-attachments/assets/cfd1187e-c6e8-441c-9e9c-3e20cba22ce1" />


**Our Contribution**

• We propose a balanced design targeting low area, low power, and reasonable clock frequency.

• We implement our design using advanced 16 nm FinFET technology to match modern trends.

• We reduce clock cycles by using a serialized architecture with a single S-box in the permutation phase.

• On Lattice iCE40 FPGA, we achieve 200 MHz with only 418 FFs and 582 LUTs.

• On TSMC 16-nm technology, we reach 100 MHz with an area of 1.341 KGE and 0.254 mW power consumption.

