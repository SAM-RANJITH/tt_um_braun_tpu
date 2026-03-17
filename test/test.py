import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
import os


@cocotb.test()
async def test_tpu_3x3_with_waveform(dut):

    dut._log.info("🚀 Starting 3x3 TPU Test with Waveform")

    # ---------------------------------
    # Enable waveform dump
    # ---------------------------------
    os.environ["WAVES"] = "1"

    # ---------------------------------
    # Clock (50 MHz → 20ns)
    # ---------------------------------
    clock = Clock(dut.clk, 20, unit="ns")
    cocotb.start_soon(clock.start())

    # ---------------------------------
    # Reset
    # ---------------------------------
    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    await ClockCycles(dut.clk, 5)

    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # ---------------------------------
    # Start TPU
    # ---------------------------------
    dut.ena.value = 1

    # ---------------------------------
    # LOAD MATRIX A
    # A = [2, 3, 4]
    # ---------------------------------
    dut._log.info("Loading Matrix A")

    dut.ui_in.value = 2
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 3
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 4
    await ClockCycles(dut.clk, 1)

    # ---------------------------------
    # LOAD MATRIX B
    # B = [1, 2, 3]
    # ---------------------------------
    dut._log.info("Loading Matrix B")

    dut.ui_in.value = 1
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 2
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 3
    await ClockCycles(dut.clk, 1)

    # Stop loading
    dut.ena.value = 0

    # ---------------------------------
    # Wait for compute + delay pipeline
    # ---------------------------------
    dut._log.info("Waiting for computation...")
    await ClockCycles(dut.clk, 20)

    # ---------------------------------
    # Read output stream
    # ---------------------------------
    dut._log.info("Reading outputs")

    for i in range(9):
        await ClockCycles(dut.clk, 1)

        value = int(dut.uo_out.value)
        index = int(dut.uio_out.value) & 0xF

        dut._log.info(f"Output[{index}] = {value}")

    dut._log.info("✅ Test Completed")

    # ---------------------------------
    # Inform user about waveform
    # ---------------------------------
    dut._log.info("📊 Waveform generated! Open with GTKWave")
