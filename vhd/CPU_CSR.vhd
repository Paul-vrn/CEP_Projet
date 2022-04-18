library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PKG.all;

entity CPU_CSR is
    generic (
        INTERRUPT_VECTOR : waddr   := w32_zero;
        mutant           : integer := 0
    );
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;

        -- Interface de et vers la PO
        cmd         : in  PO_cs_cmd;
        it          : out std_logic;
        pc          : in  w32;
        rs1         : in  w32;
        imm         : in  W32;
        csr         : out w32;
        mtvec       : out w32;
        mepc        : out w32;

        -- Interface de et vers les IP d'interruption
        irq         : in  std_logic;
        meip        : in  std_logic;
        mtip        : in  std_logic;
        mie         : out w32;
        mip         : out w32;
        mcause      : in  w32
    );
end entity;

architecture RTL of CPU_CSR is
    -- Fonction retournant la valeur à écrire dans un csr en fonction
    -- du « mode » d'écriture, qui dépend de l'instruction
    function CSR_write (CSR        : w32;
                         CSR_reg    : w32;
                         WRITE_mode : CSR_WRITE_mode_type)
        return w32 is
        variable res : w32;
    begin
        case WRITE_mode is
            when WRITE_mode_simple =>
                res := CSR;
            when WRITE_mode_set =>
                res := CSR_reg or CSR;
            when WRITE_mode_clear =>
                res := CSR_reg and (not CSR);
            when others => null;
        end case;
        return res;
    end CSR_write;

    signal to_csr : w32;
    signal mcause_q : w32;
    signal mstatus : w32;

begin
    to_csr <= rs1 when cmd.TO_CSR_sel = TO_CSR_from_rs1 else imm;  


    csr <=  mcause_q when cmd.CSR_sel = CSR_from_mcause else
            mepc when cmd.CSR_sel = CSR_from_mepc else
            mtvec when cmd.CSR_sel = CSR_from_mtvec else
            mstatus when cmd.CSR_sel = CSR_from_mstatus else
            mie when cmd.CSR_sel = CSR_from_mie else
            mip when cmd.CSR_sel = CSR_from_mip;
        
    it <= irq and mstatus(3);

    process (clk)
    begin
        if rising_edge(clk) then

            if irq = '1' then
                mcause_q <= mcause;
            end if;
    
            mip(7) <= mtip;
            mip(11) <= meip;
        
            
--            if (cmd.CSR_we=CSR_mtvec) then
--                mtvec <= CSR_write(to_csr, mtvec, cmd.CSR_write_mode);
--            elsif (cmd.CSR_we=CSR_mepc) then
--                mepc  <= CSR_write(pc, mepc, cmd.CSR_write_mode);
--            elsif (cmd.CSR_we=CSR_mie) then
--                mie <= CSR_write(to_csr, mie, cmd.CSR_write_mode);
--            elsif (cmd.CSR_we=CSR_mstatus) then
--                mstatus <= CSR_write(to_csr, mstatus, cmd.CSR_write_mode);
--            end if;
            case cmd.CSR_we is 
            when CSR_mepc =>
                if cmd.MEPC_sel = MEPC_from_csr then
                    mepc <= CSR_write(TO_CSR, mepc, cmd.CSR_WRITE_mode)(31 downto 2)&"00";
                elsif cmd.MEPC_sel = MEPC_from_pc then
                    mepc <= CSR_write(pc, mepc, cmd.CSR_WRITE_mode)(31 downto 2)&"00";
                end if;
            when CSR_mtvec =>
                mtvec <= CSR_write(to_csr, mtvec, cmd.CSR_WRITE_mode)(31 downto 2)&"00"; 
            when CSR_mie =>
                mie <= CSR_write(to_csr, mie, cmd.CSR_WRITE_mode);
            when CSR_mstatus =>
                mstatus <= CSR_write(to_csr, mstatus, cmd.CSR_WRITE_mode);
            when others => null;
            end case;
            if cmd.MSTATUS_mie_set = '1' then
                mstatus(3) <= '1';
            end if;
            if cmd.MSTATUS_mie_reset = '1' then
                mstatus(3) <= '0';
            end if;

            if rst = '1' then
                mcause_q <= w32_zero;
                mip <= w32_zero;
                mstatus <= w32_zero;
                mie <= w32_zero;
                mtvec <= w32_zero;
                mepc <= w32_zero;
            end if;
        end if;
    end process;
end architecture;

