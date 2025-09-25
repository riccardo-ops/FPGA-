# Lancia la simulazione batch o GUI
launch_simulation

# (Facoltativo: run simulation per il tempo desiderato)
run 30 ms

open_wave_config ./xsim.dir/e_UartTb_behav/e_UartTb_behav.wcfg

# (Ripristina all'ultimo stato di salvata)
reload_waves
