-- file: clockgen_bytelink.vhd
-- 
-- (c) Copyright 2008 - 2011 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
------------------------------------------------------------------------------
-- User entered comments
------------------------------------------------------------------------------
-- None
--
------------------------------------------------------------------------------
-- "Output    Output      Phase     Duty      Pk-to-Pk        Phase"
-- "Clock    Freq (MHz) (degrees) Cycle (%) Jitter (ps)  Error (ps)"
------------------------------------------------------------------------------
-- CLK_OUT1___106.651______0.000______50.0______387.528____150.000
--
------------------------------------------------------------------------------
-- "Input Clock   Freq (MHz)    Input Jitter (UI)"
------------------------------------------------------------------------------
-- __primary___________21.33____________0.010

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity clockgen_bytelink is
port
 (-- Clock in ports
  SST_CLK_IN           : in     std_logic:= '0' ;  
  -- Clock out ports
  SSTx5_CLK_OUT          : out    std_logic := '0' ; 
  -- Status and control signals
  RESET             : in     std_logic := '0' ; 
  LOCKED            : out    std_logic := '0'
 );
end clockgen_bytelink;

architecture xilinx of clockgen_bytelink is
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of xilinx : architecture is "clockgen_bytelink,clk_wiz_v3_6,{component_name=clockgen_bytelink,use_phase_alignment=true,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=false,feedback_source=FDBK_AUTO,primtype_sel=DCM_SP,num_out_clk=1,clkin1_period=46.882,clkin2_period=46.882,use_power_down=false,use_reset=true,use_locked=true,use_inclk_stopped=false,use_status=false,use_freeze=false,use_clk_valid=false,feedback_type=SINGLE,clock_mgr_type=AUTO,manual_override=false}";
	  -- Input clock buffering / unused connectors
  signal clkin1            : std_logic:= '0' ; 
  -- Output clock buffering
  signal clkfb             : std_logic:= '0' ; 
  signal clk0              : std_logic:= '0' ; 
  signal clkfx             : std_logic:= '0' ; 
  signal clkfbout          : std_logic:= '0' ; 
  signal locked_internal   : std_logic:= '0' ; 
  signal status_internal   : std_logic_vector(7 downto 0) := (others => '0');
  signal i_reset           : std_logic := '0' ; 
  signal i : integer := 0;
begin


  -- Input buffering
  --------------------------------------
  clkin1 <= SST_CLK_IN;


  -- Clocking primitive
  --------------------------------------
  
  -- Instantiation of the DCM primitive
  --    * Unused inputs are tied off
  --    * Unused outputs are labeled unused
  dcm_sp_inst: DCM_SP
  generic map
   (CLKDV_DIVIDE          => 2.000,
    CLKFX_DIVIDE          => 2,
    CLKFX_MULTIPLY        => 10,
    CLKIN_DIVIDE_BY_2     => FALSE,
    CLKIN_PERIOD          => 46.882,
    CLKOUT_PHASE_SHIFT    => "NONE",
    CLK_FEEDBACK          => "1X",
    DESKEW_ADJUST         => "SYSTEM_SYNCHRONOUS",
    PHASE_SHIFT           => 0,
    STARTUP_WAIT          => FALSE)
  port map
   -- Input clock
   (CLKIN                 => clkin1,
    CLKFB                 => clkfb,
    -- Output clocks
    CLK0                  => clk0,
    CLK90                 => open,
    CLK180                => open,
    CLK270                => open,
    CLK2X                 => open,
    CLK2X180              => open,
    CLKFX                 => clkfx,
    CLKFX180              => open,
    CLKDV                 => open,
   -- Ports for dynamic phase shift
    PSCLK                 => '0',
    PSEN                  => '0',
    PSINCDEC              => '0',
    PSDONE                => open,
   -- Other control and status signals
    LOCKED                => locked_internal,
    STATUS                => status_internal,
    RST                   => i_reset,
   -- Unused pin, tie low
    DSSEN                 => '0');

    Locked                <= locked_internal;
 process(clkin1)

 constant i_max : integer := 3;
 begin 

 if rising_edge(clkin1)  then 
	
	
	if (RESET = '1' or i >  0 ) and i < i_max    then 
	
		i_reset <= '1';
		i <= i+1;
	elsif   i >= i_max then 
	  i <= 0 ;
     i_reset <= '0';
	end if;
	


	
 end if;
 
 end process;



  -- Output buffering
  -------------------------------------
  clkf_buf : BUFG
  port map
   (O => clkfb,
    I => clk0);


  clkout1_buf : BUFG
  port map
   (O   => SSTx5_CLK_OUT,
    I   => clkfx);



end xilinx;
