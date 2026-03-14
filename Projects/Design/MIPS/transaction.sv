package pkg;

/*
    class CU_transaction;

        rand logic [31:0] stim [99:0];

        constraint instruction_c {
            foreach(stim[i]) {
                stim[i][31:26] inside {
                    6'b000000, 6'b100011, 6'b101011, 6'b000100, 6'b001000, 6'b000010
                };
                stim[i][5:0] inside {
                    6'b000000, 6'b000001, 6'b000010, 6'b000011, 6'b000100
                };
            }
        }

    endclass
*/

    class MIPS_transaction;
        rand logic    [31:0] instr [255:0];
        rand logic    [31:0] data_in[255:0];

        constraint instruction_c {
            foreach (instr[i]) {
                instr[i][31:26] inside {6'b000000, 6'b100011, 6'b101011, 6'b000100, 6'b001000, 6'b000010};

                if (instr[i][31:26] == 6'b000000) {
                    instr[i][5:0] inside {6'b000000, 6'b000001, 6'b000010, 6'b000011, 6'b000100};
                }
            }
        }

    endclass


endpackage
