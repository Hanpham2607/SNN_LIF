# SNN_LIF

This project implements a **Spiking Neural Network (SNN)** on FPGA, utilizing the **Leaky Integrate-and-Fire (LIF)** neuron model.

## 📷 System Architecture
The design integrates cascaded adders, control units, and memory blocks for efficient processing.

![SNN Architecture](SNN_LIF.jpg)

## 🛠️ Tech Stack
* **Language:** Verilog / SystemVerilog
* **Algorithm:** LIF Neuron Model, Cascaded Adders
* **Tools:** Quartus (Synthesis), ModelSim (Simulation)

## 🚀 Overview
* Input spikes and weights are processed using **Cascaded Adders**.
* The **LIF model** calculates membrane potential to generate output spikes.
* Designed for efficient hardware resource utilization on FPGA.
