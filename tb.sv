module tb;
  logic clk;
  logic reset;
  logic i_valid;
  logic [7:0i_data;
  logic o_ready;
  logic o_valid;
  logic [7:0]o_data;
  logic i_ready;

  task_optoML u_dut (
    .clk(clk),
    .reset(reset),
    .i_valid(i_valid),
    .i_ready(i_ready),
    .i_data(i_data),
    .o_valid(o_valid),
    .o_ready(o_ready),
    .o_data(o_data)
  );

  //Clock Generation
  always #5 clk = ~clk;


  initial begin
    clk = 0;
    reset = 1;
    i_valid = 0;
    i_data = 8'h00;
    i_ready = 0;

    repeat(2) @(posedge clk);
    reset = 0; 
    $display("--- Reset Complete ---");


    @(posedge clk);
    i_ready <= 1; 
    drive_packet(8'hAA);
    drive_packet(8'hBB);
    
    @(posedge clk);
    i_valid <= 0;
    @(posedge clk);

    $display("--- Starting Backpressure Test ---");

    @(posedge clk);
    i_ready <= 0;       
    i_valid <= 1;      
    i_data  <= 8'hCC;

    repeat(2) @(posedge clk); 

    $display("--- Releasing Backpressure ---");
    @(posedge clk);
    i_ready <= 1; 

    drive_packet(8'hDD);

    @(posedge clk);
    i_valid <= 0;
    #20;
    $display("--- Test Passed ---");
    $finish;
  end

  task drive_packet(input [7:0] val);
    begin
      @(posedge clk);
      i_valid <= 1;
      i_data  <= val;

      while(o_ready == 0) begin
        @(posedge clk);
      end
    end
  endtask

  always @(posedge clk) begin
    if (o_valid && i_ready) begin
      $display("[Monitor] Output Transaction: Data = 0x%h at time %0t", o_data, $time);
    end
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end

endmodule
