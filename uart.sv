module uart(input clk,rst,
  input [0:7]data,
  output logic tx,
  output logic tx_out
  );
  parameter baud_rate=1;
  typedef enum logic [1:0] {
  IDLE,
  START,
  DATA,
  STOP
  } states;
  
  states state,next_state;
  logic [0:7] tx_buff;
  logic [5:0] count;
  logic  [2:0]bit_in;
  logic g_clk;
  always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
      tx<=0;
      tx_out<=0;
      tx_buff<=0;
      count<=0;
      bit_in <= 0;
      state<=IDLE;
      next_state <= IDLE;
      g_clk = 0;
    end
    else 
      count = count + 1;
    if(count == baud_rate) begin
      g_clk <= !g_clk;
      count <= 0;
      state <= next_state;
    end
  end
  
  always_ff @(posedge g_clk) begin
    case(state)
      IDLE: begin
     	  tx<=0;
        tx_buff <= 0;
        tx_out <= 0;
        bit_in <= 0;
        next_state <= START;
    		end
      START: begin
     	  tx<=0;
        tx_buff <= data;
        next_state <= DATA;
      end
      DATA: begin
        tx <= 1;
 	      tx_out <= tx_buff[bit_in];
        bit_in <= bit_in+1;
        if(bit_in == 7)
          next_state <= STOP;           
      end
      STOP: begin
        tx <= 0;
        tx_out <= 0;
       	tx_buff<=0;
 		    next_state <= IDLE;
  		  end
    endcase
  end

  endmodule