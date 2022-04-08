library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PKG.all;


entity CPU_PC is
    generic(
        mutant: integer := 0
    );
    Port (
        -- Clock/Reset
        clk    : in  std_logic ;
        rst    : in  std_logic ;

        -- Interface PC to PO
        cmd    : out PO_cmd ;
        status : in  PO_status
    );
end entity;

architecture RTL of CPU_PC is
    type State_type is (
        S_Error,
        S_Init,
        S_Pre_Fetch,
        S_Fetch,
        S_Decode,
        S_LUI,
        S_ADDI,
        S_ARITHMETIQUE,
        S_DECALAGE,
        S_AUIPC,
        S_BRANCH,
        S_SETS,
        S_LOGIC,
        S_JAL_JALR,
        S_PRE_LOAD,
        S_LOAD,
        S_SW
    );

    signal state_d, state_q : State_type;


begin

    FSM_synchrone : process(clk)
    begin
        if clk'event and clk='1' then
            if rst='1' then
                state_q <= S_Init;
            else
                state_q <= state_d;
            end if;
        end if;
    end process FSM_synchrone;

    FSM_comb : process (state_q, status)
    begin

        -- Valeurs par défaut de cmd à définir selon les préférences de chacun
        cmd.ALU_op            <= UNDEFINED;
        cmd.LOGICAL_op        <= UNDEFINED;
        cmd.ALU_Y_sel         <= UNDEFINED;

        cmd.SHIFTER_op        <= UNDEFINED;
        cmd.SHIFTER_Y_sel     <= UNDEFINED;

        cmd.RF_we             <= 'U';
        cmd.RF_SIZE_sel       <= UNDEFINED;
        cmd.RF_SIGN_enable    <= 'U';
        cmd.DATA_sel          <= UNDEFINED;

        cmd.PC_we             <= 'U';
        cmd.PC_sel            <= UNDEFINED;

        cmd.PC_X_sel          <= UNDEFINED;
        cmd.PC_Y_sel          <= UNDEFINED;

        cmd.TO_PC_Y_sel       <= UNDEFINED;

        cmd.AD_we               <= 'U';
        cmd.AD_Y_sel          <= UNDEFINED;

        cmd.IR_we             <= 'U';

        cmd.ADDR_sel          <= UNDEFINED;
        cmd.mem_we            <= 'U';
        cmd.mem_ce            <= 'U';

        cmd.cs.CSR_we            <= UNDEFINED;

        cmd.cs.TO_CSR_sel        <= UNDEFINED;
        cmd.cs.CSR_sel           <= UNDEFINED;
        cmd.cs.MEPC_sel          <= UNDEFINED;

        cmd.cs.MSTATUS_mie_set   <= 'U';
        cmd.cs.MSTATUS_mie_reset <= 'U';

        cmd.cs.CSR_WRITE_mode    <= UNDEFINED;

        state_d <= state_q;

        case state_q is
            when S_Error =>
                -- Etat transitoire en cas d'instruction non reconnue 
                -- Aucune action
                state_d <= S_Init;

            when S_Init =>
                -- PC <- RESET_VECTOR
                cmd.PC_we <= '1';
                cmd.PC_sel <= PC_rstvec;
                state_d <= S_Pre_Fetch;

            when S_Pre_Fetch =>
                -- mem[PC]
                cmd.mem_we   <= '0';
                cmd.mem_ce   <= '1';
                cmd.ADDR_sel <= ADDR_from_pc;
                state_d      <= S_Fetch;

            when S_Fetch =>
                -- IR <- mem_datain
                cmd.IR_we <= '1';
                state_d <= S_Decode;

            when S_Decode =>
                case status.IR(6 downto 0) is 
                    when "0110111" =>
                        cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                        cmd.PC_sel <= PC_from_pc;
                        cmd.PC_we <= '1';
                        state_d <= S_LUI;
                    when "0010011" =>
                        cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                        cmd.PC_sel <= PC_from_pc;
                        cmd.PC_we <= '1';
                        case status.IR(14 downto 12) is
                            when "000" =>
                                state_d <= S_ADDI;
                            when "010" => -- slti | sltiu
                                state_d <= S_SETS;
                            when "011" => -- sltiu
                                cmd.RF_SIGN_enable <= '0';
                                state_d <= S_SETS;
                            when "100" | "110" | "111" => -- xori | ori | andi
                                state_d <= S_LOGIC;
                            when "001" | "101" => -- slli | (srai | srli)
                                state_d <= S_DECALAGE;
                            when others =>
                                state_d <= S_Error;
                            end case;
                    when "0110011" =>
                        cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                        cmd.PC_sel <= PC_from_pc;
                        cmd.PC_we <= '1';
                        case status.IR(14 downto 12) is
                            when "000" => -- add et sub
                                state_d <= S_ARITHMETIQUE;
                            when "001" | "101" => -- sll | (sra | srl)
                                state_d <= S_DECALAGE;
                            when "010" => -- slt 
                                state_d <= S_SETS;
                            when "011" => -- sltu
                                cmd.RF_SIGN_enable <= '0';
                                state_d <= S_SETS;
                            when "100" | "110" | "111" => -- xor | or | and
                                state_d <= S_LOGIC;
                            when others => 
                                state_d <= S_Error;
                        end case;
                    when "0010111" =>
                        state_d <= S_AUIPC;
                    when "1100011" => 
                        state_d <= S_BRANCH;
                    when "0000011" =>
                        state_d <= S_CALC_AD;
                    when "1101111" | "1100111" => -- jal | jalr
                        state_d <= S_JAL_JALR;
                    when others => 
                        state_d <= S_Error;
                end case;

            when S_LOGIC =>
                if status.IR(6 downto 0)= "0010011" then
                    cmd.ALU_Y_sel <= ALU_Y_immI;
                elsif status.IR(6 downto 0) = "0110011" then
                    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                else 
                    state_d <= S_Error;
                end if;
                -- "100" | "110" | "111" => -- xor | or | and     
                if (status.IR(14 downto 12) = "100") then
                    cmd.LOGICAL_op <= LOGICAL_xor;
                elsif (status.IR(14 downto 12) = "110") then
                    cmd.LOGICAL_op <= LOGICAL_or;
                elsif (status.IR(14 downto 12) = "111") then
                    cmd.LOGICAL_op <= LOGICAL_and;
                else
                    state_d <= S_Error;
                end if; 
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_logical;
                -- lecture mém
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;    
            when S_LUI =>
                -- rd <- ImmU + 0
                cmd.PC_X_sel <= PC_X_cst_x00;
                cmd.PC_Y_sel <= PC_Y_immU;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_pc;
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_ADDI =>
                cmd.ALU_op <= ALU_plus;
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_alu;
                -- lecture mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;
            when S_ARITHMETIQUE =>
                if status.IR(31 downto 25) = "0000000" then
                    cmd.ALU_op <= ALU_plus;
                elsif status.IR(31 downto 25) = "0100000" then
                    cmd.ALU_op <= ALU_minus;
                else 
                    state_d <= S_Error;
                end if;
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_alu;
                -- lecture mém
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;
                
            when S_DECALAGE =>
                if (status.IR(6 downto 0) = "0010011") then
                    cmd.SHIFTER_Y_sel <= SHIFTER_Y_ir_sh;
                elsif (status.IR(6 downto 0) = "0110011") then
                    cmd.SHIFTER_Y_sel <= SHIFTER_Y_rs2;
                else 
                    state_d <= S_Error;
                end if;
                -- when "001" | "101" | => -- sll | (sra | srl)
                if (status.IR(14 downto 12) = "001") then
                    cmd.SHIFTER_op <= SHIFT_ll;
                elsif (status.IR(14 downto 12) = "101") then
                    if (status.IR(31 downto 25) = "0100000") then
                        cmd.SHIFTER_op <= SHIFT_ra;
                    elsif (status.IR(31 downto 25) = "0000000") then
                        cmd.SHIFTER_op <= SHIFT_rl;
                    else
                        state_d <= S_Error;
                    end if;
                end if;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_shifter;

                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_AUIPC => 
                cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                cmd.PC_sel <= PC_from_pc;
                cmd.PC_we <= '1';
                cmd.RF_we <= '1';
                cmd.PC_Y_sel <= PC_Y_immU;
                cmd.PC_X_sel <= PC_X_pc;
                cmd.DATA_sel <= DATA_from_pc;
                cmd.PC_sel <= PC_from_pc;
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_we <= '0';
                state_d <= S_Pre_Fetch;
            when S_BRANCH =>                 
                cmd.ADDR_sel <= ADDR_from_pc;
                if (status.jcond) then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_immB;
                else
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                end if;
                cmd.DATA_sel <= DATA_from_slt;
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.PC_we <= '1';
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.PC_sel <= PC_from_pc;
                state_d <= S_Pre_Fetch;
            when S_SETS => 
                if status.IR(6 downto 0)= "0010011" then
                    cmd.ALU_Y_sel <= ALU_Y_immI;
                elsif status.IR(6 downto 0)= "0110011" then
                    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                else
                    state_d <= S_Error;
                end if;
                cmd.DATA_sel <= DATA_from_slt;
                cmd.RF_we <= '1';
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                state_d <= S_Fetch;
            
            when S_CALC_AD => 
                cmd.AD_we <= '1';
                cmd.AD_Y_sel <= AD_Y_immI;
                state_d <= S_PRE_FETCH;
            when S_PRE_LOAD => -- met AD dans la mem
                cmd.ADDR_sel <= ADDR_from_ad;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';

                cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                cmd.PC_sel <= PC_from_pc;
                cmd.PC_we <= '1';


                state_d <= S_LOAD;
            when S_LOAD => -- récup AD et le met dans rd
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.RF_we <= '1';
                cmd.RF_SIZE_sel <= RF_SIZE_word;
                cmd.RF_SIGN_enable <= '0';
                --if (status.IR(14 downto 12)= "010") then -- lw
                --  cmd.RF_SIZE_sel <= RF_SIZE_word;
                --elsif (status.IR(14 downto 12)= "000") then -- lb
                --  cmd.RF_SIZE_sel <= RF_SIZE_byte;
                --  cmd.RF_SIGN_enable <= '0';
                --elsif (status.IR(14 downto 12)= "100") then -- lbu
                --  cmd.RF_SIZE_sel <= RF_SIZE_byte;
                --  cmd.RF_SIGN_enable <= '1';
                --elsif (status.IR(14 downto 12)= "001") then -- lh
                --  cmd.RF_SIZE_sel <= RF_SIZE_half;
                --  cmd.RF_SIGN_enable <= '0';
                --elsif (status.IR(14 downto 12)= "101") then -- lhu
                --  cmd.RF_SIZE_sel <= RF_SIZE_half;
                --  cmd.RF_SIGN_enable <= '1';
                --else
                --  state_d <= S_Error;
                --end if;
                cmd.DATA_sel <= DATA_from_mem;

                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                state_d <= S_Fetch;
            
            when S_SW => 
                
            when S_JAL_JALR => 
                cmd.PC_X_sel <= PC_X_pc;
                cmd.PC_Y_sel <= PC_Y_cst_x04;
                cmd.DATA_sel <= DATA_from_pc;
                cmd.RF_we <= '1';
                cmd.PC_we <= '1';
                state_d <= S_Pre_Fetch;
                if (status.IR(6 downto 0) = "1101111") then -- jal
                    cmd.TO_PC_Y_sel <= TO_PC_Y_immJ;
                    cmd.PC_sel <= PC_from_pc;
                elsif (status.IR(6 downto 0) = "1100111") then -- jalr
                    cmd.ALU_Y_sel <= ALU_Y_immI;
                    cmd.ALU_op <= ALU_plus;
                    cmd.PC_sel <= PC_from_alu;
                else
                    state_d <= S_Error;
                end if;
            when others => null;
            end case;

    end process FSM_comb;

end architecture;
