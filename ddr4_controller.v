// +FHDR----------------------------------------------------------------------------
// Project Name  : FPGA
// Device        : xcvu19p
// Author        : Juntao Guo
// Email         : 1554895045@qq.com
// Created On    : 2024/02/07 09:58
// Last Modified : 2024/02/07 10:58
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


module ddr4_op #(parameter
    DFI_CHIP_DELECT_CHIP = 1,
    DFI_DATA_ENABLE_WIDTH = 16,
    DFI_DATA_WIDTH = 128,
    A_WIDTH = 17,
    BA_WIDTH = 2,
    BG_WIDTH = 2
)(
    output  [31:0]                          t_phy_wrlat,
    output  [31:0]                          t_phy_wrdata,
    output  [31:0]                          t_rddata_en,
    output  [31:0]                          t_phy_rdlat,
    
    // clock and reset
    input                                   dfi_clk,
    input                                   dfi_phy_clk,
    input                                   reset_n,

    // control interface
    output  [A_WIDTH-1:0]                   dfi_address_p0,  
    output  [A_WIDTH-1:0]                   dfi_address_p1,  
    output  [A_WIDTH-1:0]                   dfi_address_p2,  
    output  [A_WIDTH-1:0]                   dfi_address_p3,
    output  [BG_WIDTH]                      dfi_bg_p0,  
    output  [BG_WIDTH]                      dfi_bg_p1,  
    output  [BG_WIDTH]                      dfi_bg_p2,  
    output  [BG_WIDTH]                      dfi_bg_p3,
    output  [BA_WIDTH]                      dfi_bank_p0,  
    output  [BA_WIDTH]                      dfi_bank_p1,  
    output  [BA_WIDTH]                      dfi_bank_p2,  
    output  [BA_WIDTH]                      dfi_bank_p3,
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_cke_p0,                
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_cke_p1,                
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_cke_p2,                
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_cke_p3,
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_cs_p0,  
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_cs_p1,  
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_cs_p2,  
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_cs_p3,
    output                                  dfi_ras_n_p0,  
    output                                  dfi_ras_n_p1,  
    output                                  dfi_ras_n_p2,  
    output                                  dfi_ras_n_p3,
    output                                  dfi_cas_n_p0,  
    output                                  dfi_cas_n_p1,  
    output                                  dfi_cas_n_p2,  
    output                                  dfi_cas_n_p3,
    output                                  dfi_we_n_p0,  
    output                                  dfi_we_n_p0,  
    output                                  dfi_we_n_p0,  
    output                                  dfi_we_n_p0,
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
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_wrdata_cs_p0,                
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_wrdata_cs_p1,                
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_wrdata_cs_p2,                
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_wrdata_cs_p3,
    output  [DFI_DATA_WIDTH/8-1:0]          dfi_wrdata_mask_p0,                
    output  [DFI_DATA_WIDTH/8-1:0]          dfi_wrdata_mask_p1,                
    output  [DFI_DATA_WIDTH/8-1:0]          dfi_wrdata_mask_p2,                
    output  [DFI_DATA_WIDTH/8-1:0]          dfi_wrdata_mask_p3,

    // read data interface
    output  [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_rddata_en_p0,                
    output  [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_rddata_en_p1,                
    output  [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_rddata_en_p2,                
    output  [DFI_DATA_ENABLE_WIDTH-1:0]     dfi_rddata_en_p3,
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_rddata_cs_p0,    
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_rddata_cs_p1,    
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_rddata_cs_p2,    
    output  [DFI_CHIP_DELECT_CHIP-1:0]      dfi_rddata_cs_p3,
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
    output                                  dfi_phyupd_ack,    
    input                                   dfi_ctrlupd_ack,
    input                                   dfi_phyupd_req,
    input                                   dfi_phyupd_type,

    // status interface
    output                                  dfi_dram_clk_disable,
    output  [1:0]                           dfi_freq_ratio,                
    output                                  dfi_freq_start,                
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




endmodule

// Local Variables:
// verilog-library-directories:(".")
// End:
