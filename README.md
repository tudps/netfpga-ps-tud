This is a base platform for using the NetFPGA SUME 10 Gigabit Ethernet ports with arbitrary network functions. It is fully operational and supports the following features:

* Full 10 Gigabit Ethernet Tx and Rx line rate on every port (follow instructions in the code to instantiate all 4 ports instead of only 2)
* Full LED support (link/act)
* Thorough debugging support for the board's and the core's status signals.
* A packet generator as the first network function

Although fully operational, the reference platform is still in an initial state but is planned to be extended:

* Support for partial reconfiguration (PR) of network functions
* A framework for stand-alone operation (e.g. no PCIe required)
* Various other network functions

### Dependencies and Requirements

* SUME Master XDC (get it on https://reference.digilentinc.com/sume:sume)
* IP Cores from Xilinx: 10 Gigabit Ethernet Subsystem (v3.0)
  * License for ten\_gig\_eth\_mac
  * License for ten\_gig\_eth\_pcs\_pma

The development platform used is Vivado 2015.2. For copyright reasons, we cannot include required third-party code (and maybe even stubs) into this project.

### Basic Usage

* Import the SUME Master XDC and all files under *source/* into your project.
* Uncomment all lines in the Master XDC which correspond to input/output ports in *TopLevelModule.v*.
* Ensure that *TopLevelModule.v* is set as a top level module.
* Generate an IP core *axi\_10g\_ethernet\_0*
  * Include shared logic in core
  * BASE-R
  * 64 bit operation
  * No 802.1Qbb
  * No AXI-4 Lite for Configuration and Status
* Generate an IP core *axi\_10g\_ethernet\_n*
  * Like above, but without including shared logic in core

The core should now be synthesizable and ready for implementation.

### Debugging

Using *tools/nf_debug.py*, you can decode and view the frames sent from nf_debug.v (currently assigned to eth2)
which periodically outputs status signals for debugging.
