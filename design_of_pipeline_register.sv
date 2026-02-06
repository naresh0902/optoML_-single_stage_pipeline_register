module task_optoML( 
  input logic clk,
  input logic reset,

  //i-prefix is used for all the input signals for clarity
  // handshake signals 
  input logic i_valid,
  input logic i_ready,
  input logic [7:0] i_data,
  //o-prefix is used for all the output signlas for clarity
  output logic o_valid,
  output logic o_ready,
  output logic [7:0] o_data);
  
  logic [7:0] data_register; //register to store data for pipeline
  logic valid_register;

  assign o_ready=i_ready|~valid_register;

  always_ff@(posedge clk) begin
    if(reset) begin
      valid_register<=0;
      data_register<=0;
    end
    else begin
      if(o_ready) begin
        valid_register<=i_valid;
        if(i_valid) begin
          data_register<=i_data;
        end
      end
    end
  end

  assign o_valid=valid_register;
  assign o_data=data_register;
endmodule
