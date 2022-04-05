library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PKG.all;

entity CPU_CND is
    generic (
        mutant      : integer := 0
    );
    port (
        rs1         : in w32;
        alu_y       : in w32;
        IR          : in w32;
        slt         : out std_logic;
        jcond       : out std_logic
    );
end entity;

architecture RTL of CPU_CND is
    signal res : unsigned(32 downto 0);
    signal ext : std_logic;
    signal z,s : std_logic;
begin

ext <= (IR(12) nor IR(6)) or (IR(6) and IR(13));
res <= ((ext and rs1(31)) & rs1) - ((ext and alu_y(31)) & alu_y);


z <= '1' when (res="0") else '0';
jcond <= ((z xor IR(12)) and (not IR(14))) or ( (res(32) xor IR(12)) and IR(14));
slt <= res(32);
end architecture;
