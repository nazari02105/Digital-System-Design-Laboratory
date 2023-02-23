module TCAM(
    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire [15:0] input_data,
    input wire [15:0] input_unknown_bits,
    output reg [15:0] hits,
    output reg write_success
);

    reg [15:0] unknown_bit_positions [15:0];
    reg [15:0] mem [15:0];
    reg [15:0] mem_filled;

    integer i, j;

    reg match_in_read;
     
    // Write part
    always @(posedge clk) begin
        // Preset values
        hits = 0;
        write_success = 0;
        // Check status
        if (reset)
            mem_filled = 0;
        else begin
            if (write_enable) begin
                for (i = 0; i < 16; i = i + 1) begin
                    // Only write if we have not written anything before and this memory is empty
                    if (!write_success && !mem_filled[i]) begin
                        write_success = 1;
                        mem[i] = input_data;
                        unknown_bit_positions[i] = input_unknown_bits;
                        mem_filled[i] = 1;
                    end
                end
            end else begin
                // Check all memory places
                for (i = 0; i < 16; i = i + 1) begin
                    // Check if there is something in memory
                    if (mem_filled[i]) begin
                        match_in_read = 1; // Assume that there is match then remove if needed later
                        for (j = 0; j < 16; j = j + 1) begin
                            // If bits are not equal and the position is not unknown (x) then remove the match
                            if (mem[i][j] != input_data[j] && !unknown_bit_positions[i][j])
                                match_in_read = 0;
                        end
                        // Check if it was a match
                        if (match_in_read)
                            hits[i] = 1;
                    end
                end
            end
        end
    end
endmodule
