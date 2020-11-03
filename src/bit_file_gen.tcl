cd /home/jonathan/git/CNNAccel/Vivado/CNNAccelTest0
open_project /home/jonathan/git/CNNAccel/Vivado/CNNAccelTest0/CNNAccelTest0.xpr
update_compile_order -fileset sources_1
open_bd_design {/home/jonathan/git/CNNAccel/Vivado/CNNAccelTest0/CNNAccelTest0.srcs/sources_1/bd/CNNA_BD/CNNA_BD.bd}
report_ip_status -name ip_status
puts upgradingIP
upgrade_ip -vlnv xilinx.com:hls:cnn:436.122 [get_ips  CNNA_BD_cnn_0_0] -log ip_upgrade.log
export_ip_user_files -of_objects [get_ips CNNA_BD_cnn_0_0] -no_script -sync -force -quiet
save_bd_design
reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 7
wait_on_run impl_1
