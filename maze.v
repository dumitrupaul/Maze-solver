`timescale 1ns / 1ps

module maze(
input 				clk,
input[5:0] 			starting_col, starting_row, 		// starting position of the maze
input 				maze_in, 							// contains the information at [row, col]
output reg [5:0] 	row, col, 							// position of the cell that needs to be read
output reg			maze_oe,							// output enable, activates maze_in signal - synchronous
output reg			maze_we, 							// write enable, marks [row, col] as a path cell (with 2) - synchronous
output reg			done);		 						// maze exit was found

`define start 'd10
`define skip 'd19
`define reading 'd20
`define check_right 'd21
`define check_front 'd22
`define check_state 'd25

`define up 0
`define right 1
`define down 2
`define left 3

reg [5:0] state = `start, next_state;
reg [1:0] direction; // current direction
reg [5:0] poz_row, poz_col; // current position
reg [5:0] etapa, next_etapa; // current stage (front/right)

always @(posedge clk) begin
	state <= next_state;
	etapa <= next_etapa;
end

always @(*) begin
	maze_oe = 0;
	maze_we = 0;

	case(state)
		
		`start: begin
			// initial direction is right
			direction = `right;

			poz_row = starting_row;
			poz_col = starting_col;

			// we mark the first position
			row = starting_row;
			col = starting_col;
			maze_we = 1;

			next_etapa = `check_right;
			next_state = `check_state;
		end

		`check_state: begin
			case(etapa)
				`check_right: begin
					case(direction)
						`up: begin
							row = poz_row;
							col = poz_col + 1;
						end
						`right: begin
							row = poz_row + 1;
							col = poz_col;
						end
						`down: begin
							row = poz_row;
							col = poz_col - 1;
						end
						`left: begin
							row = poz_row - 1;
							col = poz_col;
						end
					endcase
				end
				`check_front: begin
					case(direction)
						`up: begin
							row = poz_row - 1;
							col = poz_col;
						end
						`right: begin
							row = poz_row;
							col = poz_col + 1;
						end
						`down: begin
							row = poz_row + 1;
							col = poz_col;
						end
						`left: begin
							row = poz_row;
							col = poz_col - 1;
						end
					endcase
				end
			endcase

			// read result set by row and col next, after skipping a cycle
			maze_oe = 1;
			next_state = `skip;
		end

		// skip a cycle(debug)
		`skip: next_state = `reading;

		// read maze_in and take a decision
		`reading: begin
			case(etapa)
			`check_right: begin
				// if right is free rotate and advance
				if(maze_in == 0) begin
					direction = direction + 1;
				
					maze_we = 1;

					// refresh current position
					poz_row = row;
					poz_col = col;
					
					next_etapa = `check_right;
					next_state = `check_state;
					
				end
				// if right is not free rotate and look in the front
				else if(maze_in == 1) begin
						next_etapa = `check_front;
						next_state = `check_state;
					end
				end
			`check_front: begin
				// if front is free we advance
				if(maze_in == 0) begin
			
					maze_we = 1;

					// refresh current position
					poz_row = row;
					poz_col = col;
					
					next_etapa = `check_right;
					next_state = `check_state;
					
				end
				// if front is not free we rotate 180 degress and check right
				else if(maze_in == 1) begin
						direction = direction - 2;

						next_etapa = `check_right;
						next_state = `check_state;
					end
				end
			endcase

			// check end
			if(poz_row == 63 || poz_row == 0 || poz_col == 63 || poz_col == 0) begin
				row = poz_row;
				col = poz_col;
				done = 1;
				// final state
				next_state = 'b0;
			end
		end
		'b0: ;
		default: ;
	endcase
end

endmodule