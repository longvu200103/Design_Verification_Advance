ls
cd ..
ls
cp -r tresemi_share_folder/lab_p2_spi_tb s20522060/
ls
cd lab_p2_spi_tb
ls
cd tb/chk
ls
vi sb.sv
ls
vi predictor.sv
cd ../ ls
ls
cd tlm
ls
vi sb_tlm.sv
vi spi_tlm_pkg.svh
cd
ls
lab_p2_spi_tb
cd lab_p2_spi_tb
ls
cd tb/chk
ls
vi predictor.sv
cd ../..
source env.sh
cd sim
make compile_spi
cd ../tb/chk
vi predictor.sv
cd ../../sim
cd ../tb/chk
vi predictor.sv
** Error: ** while parsing file included at /home/s20522060/lab_p2_spi_tb/tb/chk/spi_chk_pkg.svh(13)
** at /home/s20522060/lab_p2_spi_tb/tb/chk/predictor.sv(86): (vlog-2164) Class or package 'SB_REG' not found.
** Error: ** while parsing file included at /home/s20522060/lab_p2_spi_tb/tb/chk/spi_chk_pkg.svh(13)
** at /home/s20522060/lab_p2_spi_tb/tb/chk/predictor.sv(86): (vlog-2730) Undefined variable: 'SB_REG'.
** Error: (vlog-13069) ** while parsing file included at /home/s20522060/lab_p2_spi_tb/tb/chk/spi_chk_pkg.svh(                                                                                          13)
** at /home/s20522060/lab_p2_spi_tb/tb/chk/predictor.sv(86): near "::": syntax error, unexpected ::, expecting                                                                                           ';'.
** Error: ** while parsing file included at /home/s20522060/lab_p2_spi_tb/tb/chk/spi_chk_pkg.svh(13)
** at /home/s20522060/lab_p2_spi_tb/tb/chk/predictor.sv(86): (vlog-2164) Class or package 'SB_REG' not found.
** Error: ** while parsing file included at /home/s20522060/lab_p2_spi_tb/tb/chk/spi_chk_pkg.svh(13)
** at /home/s20522060/lab_p2_spi_tb/tb/chk/predictor.sv(86): (vlog-2730) Undefined variable: 'SB_REG'.
** Error: (vlog-13069) ** while parsing file included at /home/s20522060/lab_p2_spi_tb/tb/chk/spi_chk_pkg.svh(                                                                                          13)
** at /home/s20522060/lab_p2_spi_tb/tb/chk/predictor.sv(86): near "::": syntax error, unexpected ::, expecting                                                                                           ';'.
vi predictor.sv
