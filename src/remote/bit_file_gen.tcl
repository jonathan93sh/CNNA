cd FirFilterMM_vivado
open_project FirFilterMM_vivado.xpr
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

