// +FHDR----------------------------------------------------------------------------
// Project Name  : FPGA
// Device        : xcvu19p
// Author        : Juntao Guo
// Email         : 1554895045@qq.com
// Created On    : 2024/02/07 09:58
// Last Modified : 2024/02/21 16:02
// File Name     : ddr4_controller.v
// Description   :
//         
// 
// ---------------------------------------------------------------------------------
// Modification History:
// Date         By              Version                 Change Description
// ---------------------------------------------------------------------------------
// 2024/02/07   Juntao Guo      1.0                     Original
// -FHDR----------------------------------------------------------------------------


module ddr4_controller #(parameter
    DFI_CHIP_SELECT_CHIP = 1,
    DFI_DATA_ENABLE_WIDTH = 16,
    DFI_DATA_WIDTH = 128,
    A_WIDTH = 17,
    BA_WIDTH = 2,
    BG_WIDTH = 2
)(
    // clock and reset
    input                                   dfi_clk,
    input                                   reset_n,

    // control interface
    output  [A_WIDTH-1:0]                   dfi_address_p0,  
    output  [A_WIDTH-1:0]                   dfi_address_p1,  
    output  [A_WIDTH-1:0]                   dfi_address_p2,  
    output  [A_WIDTH-1:0]                   dfi_address_p3,
    output  [BG_WIDTH-1:0]                  dfi_bg_p0,  
    output  [BG_WIDTH-1:0]                  dfi_bg_p1,  
    output  [BG_WIDTH-1:0]                  dfi_bg_p2,  
    output  [BG_WIDTH-1:0]                  dfi_bg_p3,
    output  [BA_WIDTH-1:0]                  dfi_bank_p0,  
    output  [BA_WIDTH-1:0]                  dfi_bank_p1,  
    output  [BA_WIDTH-1:0]                  dfi_bank_p2,  
    output  [BA_WIDTH-1:0]                  dfi_bank_p3,
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_cke_p0,                
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_cke_p1,                
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_cke_p2,                
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_cke_p3,
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_cs_p0,  
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_cs_p1,  
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_cs_p2,  
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_cs_p3,
    output                                  dfi_ras_n_p0,  
    output                                  dfi_ras_n_p1,  
    output                                  dfi_ras_n_p2,  
    output                                  dfi_ras_n_p3,
    output                                  dfi_cas_n_p0,  
    output                                  dfi_cas_n_p1,  
    output                                  dfi_cas_n_p2,  
    output                                  dfi_cas_n_p3,
    output                                  dfi_we_n_p0,  
    output                                  dfi_we_n_p1,  
    output                                  dfi_we_n_p2,  
    output                                  dfi_we_n_p3,
    output                                  dfi_act_n_p0,  
    output                                  dfi_act_n_p1,  
    output                                  dfi_act_n_p2,  
    output                                  dfi_act_n_p3,
    output [DFI_CHIP_DELECT_WIDTH-1:0]      dfi_reset_n_p0                
    output [DFI_CHIP_DELECT_WIDTH-1:0]      dfi_reset_n_p1                
    output [DFI_CHIP_DELECT_WIDTH-1:0]      dfi_reset_n_p2                
    output [DFI_CHIP_DELECT_WIDTH-1:0]      dfi_reset_n_p3

    // write data interface
    output  [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_wrdata_en_p0,                
    output  [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_wrdata_en_p1,                
    output  [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_wrdata_en_p2,                
    output  [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_wrdata_en_p3,
    output  [DFI_DATA_WIDTH-1:0]            dfi_wrdata_p0,                
    output  [DFI_DATA_WIDTH-1:0]            dfi_wrdata_p1,                
    output  [DFI_DATA_WIDTH-1:0]            dfi_wrdata_p2,                
    output  [DFI_DATA_WIDTH-1:0]            dfi_wrdata_p3,
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_wrdata_cs_p0,                
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_wrdata_cs_p1,                
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_wrdata_cs_p2,                
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_wrdata_cs_p3,
    output  [DFI_DATA_WIDTH/8-1:0]          dfi_wrdata_mask_p0,                
    output  [DFI_DATA_WIDTH/8-1:0]          dfi_wrdata_mask_p1,                
    output  [DFI_DATA_WIDTH/8-1:0]          dfi_wrdata_mask_p2,                
    output  [DFI_DATA_WIDTH/8-1:0]          dfi_wrdata_mask_p3,

    // read data interface
    output  [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_rddata_en_p0,                
    output  [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_rddata_en_p1,                
    output  [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_rddata_en_p2,                
    output  [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_rddata_en_p3,
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_rddata_cs_p0,    
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_rddata_cs_p1,    
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_rddata_cs_p2,    
    output  [DFI_CHIP_SELECT_CHIP-1:0]      dfi_rddata_cs_p3,
    input   [DFI_DATA_WIDTH-1:0]            dfi_rddata_w0,
    input   [DFI_DATA_WIDTH-1:0]            dfi_rddata_w1,
    input   [DFI_DATA_WIDTH-1:0]            dfi_rddata_w2,
    input   [DFI_DATA_WIDTH-1:0]            dfi_rddata_w3,
    input   [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_rddata_valid_w0,
    input   [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_rddata_valid_w1,
    input   [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_rddata_valid_w2,
    input   [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_rddata_valid_w3,
    input   [DFI_DATA_WIDTH/8-1:0]          dfi_rddata_dnv_w0,
    input   [DFI_DATA_WIDTH/8-1:0]          dfi_rddata_dnv_w1,
    input   [DFI_DATA_WIDTH/8-1:0]          dfi_rddata_dnv_w2,
    input   [DFI_DATA_WIDTH/8-1:0]          dfi_rddata_dnv_w3,
    input   [DFI_DATA_WIDTH/8-1:0]          dfi_rddata_dbi_w0,
    input   [DFI_DATA_WIDTH/8-1:0]          dfi_rddata_dbi_w1,
    input   [DFI_DATA_WIDTH/8-1:0]          dfi_rddata_dbi_w2,
    input   [DFI_DATA_WIDTH/8-1:0]          dfi_rddata_dbi_w3,

    // update interface
    output                                  dfi_ctrlupd_req,     
    input                                   dfi_ctrlupd_ack,
    input                                   dfi_phyupd_req,
    output                                  dfi_phyupd_ack, 
    input   [1:0]                           dfi_phyupd_type,

    // status interface
    output                                  dfi_dram_clk_disable,
    output  [1:0]                           dfi_freq_ratio,                
    output                                  dfi_init_start,                
    input                                   dfi_init_complete,
    output                                  dfi_parity_in_p0,                
    output                                  dfi_parity_in_p1,                
    output                                  dfi_parity_in_p2,                
    output                                  dfi_parity_in_p3,
    input                                   dfi_init_complete,
    input                                   dfi_alert_n_a0,                
    input                                   dfi_alert_n_a1,                
    input                                   dfi_alert_n_a2,                
    input                                   dfi_alert_n_a3,
    output  [5:0]                           dfi_frequency,

    output                                  dfi_lp_ctrl_req,
    output                                  dfi_lp_data_req,
    output                                  dfi_lp_wakeup,
    input                                   dfi_lp_ack,

    input                                   dfi_error,
    input                                   dfi_error_info                
);

localparam ININ_SM_IDLE = 0;
localparam ININ_SM_SHANKHAND = 1;
localparam ININ_SM_WAIT = 2;

// DDR4 command
// CMD = {CS_n, ACT_n, RAS_n_A16, CAS_n_AA15, WE_n_A14}
localparam NOP = 5'b0_1111;
localparam PREA = 5'b0_1010; // a10=1


reg     [4:0]   init_cnt;
reg             dfi_init_start_pre_reg;
reg     [2:0]   init_sm; // state machine
reg     [2:0]   init_sm_reg; // state machine
reg             dfi_reset_n_p0_pre_reg;

// lp
assign dfi_lp_ctrl_req = 1'b0;
assign dfi_lp_data_req = 1'b0;
assign dfi_lp_wakeup = 1'b0;

// status
assign dfi_dram_clk_disable = 1'b0;
assign dfi_freq_ratio = 2'b0;


always @(posedge dfi_clk or negedge reset_n)
    if(~reset_n)
        init_cnt <= 1'b0;
    else if(~init_cnt[4])
        init_cnt <= init_cnt + 1'b1;

always @(posedge clk or negedge reset_n)
    if(~reset_n)
        init_sm_reg <= INIT_SM_IDLE;
    else
        init_sm_reg <= init_sm;

always @(*) 
case(init_sm_reg)
    INIT_SM_IDLE:
        if(init_cnt[4])
            init_sm <= INIT_SM_SHAKEHAND;
        else
            init_sm <= INIT_SM_IDLE;
    INIT_SM_SHAKEHAND:
        if(dfi_init_start && dfi_init_complete)
            init_sm <= INIT_SM_WAIT;
        else
            init_sm <= INIT_SM_SHAKEHAND;
    INIT_SM_WAIT:
        init_sm <= INIT_SM_WAIT;
    default:
        init_sm <= INIT_SM_IDLE;
endcase          
    
always @(*) 
case(init_sm_reg)
    INIT_SM_SHAKEHAND:
        dfi_init_start_pre_reg <= 1'b1;
    default:
        dfi_init_start_pre_reg <= 1'b0;    
endcase

always @(*) 
case(init_sm_reg)
    INIT_SM_IDLE:
        dfi_reset_n_p0_pre_reg <= |init_cnt[4:2];
    INIT_SM_SHAKEHAND:
        dfi_reset_n_p0_pre_reg <= 1'b1;
    INIT_SM_WAIT:
        dfi_reset_n_p0_pre_reg <= 1'b1;
    default:
        dfi_reset_n_p0_pre_reg <= 1'b0;
endcase

assign dfi_reset_n_p0 = dfi_reset_n_p0_pre_reg;
assign dfi_reset_n_p1 = 1'b0;
assign dfi_reset_n_p2 = 1'b0;
assign dfi_reset_n_p3 = 1'b0;         

assign dfi_init_start = dfi_init_start_pre_reg;

assign dfi_frequency = 5'b0;
assign dfi_dram_clk_disable = 1'b0;
assign dfi_ctrlupd_req = 1'b0;
assign dfi_phyupd_ack = 1'b0;
assign {dfi_cke_p3, dfi_cke_p2, dfi_cke_p1, dfi_cke_p0} = 4'hf;
assign {dfi_cs_p3, dfi_cs_p2, dfi_cs_p1, dfi_cs_p0} = 4'h0; 
assign {dfi_act_n_p3, dfi_act_n_p2, dfi_act_n_p1, dfi_act_n_p0} = 4'hf; 
assign {dfi_ras_n_p3, dfi_ras_n_p2, dfi_ras_n_p1, dfi_ras_n_p0} = 4'hf; 
assign {dfi_cas_n_p3, dfi_cas_n_p2, dfi_cas_n_p1, dfi_cas_n_p0} = 4'hf; 
assign {dfi_we_n_p3, dfi_we_n_p2, dfi_we_n_p1, dfi_we_n_p0} = 4'hf;

assign dfi_address_p0 = 'b0;
assign dfi_address_p1 = 'b0;
assign dfi_address_p2 = 'b0;
assign dfi_address_p3 = 'b0;
assign dfi_bg_p0 = 'b0; 
assign dfi_bg_p1 = 'b0; 
assign dfi_bg_p2 = 'b0; 
assign dfi_bg_p3 = 'b0; 
assign dfi_bank_p0 = 'b0; 
assign dfi_bank_p1 = 'b0; 
assign dfi_bank_p2 = 'b0; 
assign dfi_bank_p3 = 'b0;
assign dfi_wrdata_en_p0 = 'b0; 
assign dfi_wrdata_en_p1 = 'b0; 
assign dfi_wrdata_en_p2 = 'b0; 
assign dfi_wrdata_en_p3 = 'b0;
assign dfi_wrdata_p0 = 'b0; 
assign dfi_wrdata_p1 = 'b0; 
assign dfi_wrdata_p2 = 'b0; 
assign dfi_wrdata_p3 = 'b0;
assign dfi_wrdata_cs_p0 = 'b0; 
assign dfi_wrdata_cs_p1 = 'b0; 
assign dfi_wrdata_cs_p2 = 'b0; 
assign dfi_wrdata_cs_p3 = 'b0; 
assign dfi_wrdata_mask_p0 = 'b0; 
assign dfi_wrdata_mask_p1 = 'b0; 
assign dfi_wrdata_mask_p2 = 'b0; 
assign dfi_wrdata_mask_p3 = 'b0;
assign dfi_rddata_en_p0 = 'b0;
assign dfi_rddata_en_p1 = 'b0;
assign dfi_rddata_en_p2 = 'b0;
assign dfi_rddata_en_p3 = 'b0;
assign dfi_rddata_cs_p0 = 'b0;
assign dfi_rddata_cs_p1 = 'b0;
assign dfi_rddata_cs_p2 = 'b0;
assign dfi_rddata_cs_p3 = 'b0;

endmodule

// Local Variables:
// verilog-library-directories:(".")
// End:
