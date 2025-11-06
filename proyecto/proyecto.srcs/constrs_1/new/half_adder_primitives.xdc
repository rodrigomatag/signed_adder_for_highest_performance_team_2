################################################################################
# 1. Restricción de Reloj Principal
################################################################################
# Define el reloj de entrada 'clk' con un periodo de 5.000 ns (200 MHz).
# Este es el paso crucial para el Análisis de Temporización (Timing Analysis).
create_clock -period 5.000 -name sys_clk [get_ports clk]


################################################################################
# 2. Restricciones de Entradas (Input Delay)
################################################################################
# Define un retardo máximo y mínimo en la entrada para los pines 'a' y 'b'.
# Esto simula el tiempo que tarda la señal en llegar a la FPGA desde el chip fuente.
# Se usa 'sys_clk' como reloj de referencia.

# Max Delay (para el chequeo de Setup)
set_input_delay -clock sys_clk -max 1.000 [get_ports {a b}]

# Min Delay (para el chequeo de Hold)
set_input_delay -clock sys_clk -min 0.500 [get_ports {a b}]


################################################################################
# 3. Restricciones de Salidas (Output Delay)
################################################################################
# Define un retardo máximo y mínimo en la salida para los pines 's' y 'c'.
# Esto simula el tiempo que el chip de destino necesita para capturar la señal.

# Max Delay (para el chequeo de Setup)
set_output_delay -clock sys_clk -max 1.500 [get_ports {s c}]

# Min Delay (para el chequeo de Hold)
set_output_delay -clock sys_clk -min 0.500 [get_ports {s c}]


################################################################################
# 4. Pines Asíncronos (Reset)
################################################################################
# El pin 'arst_n' es asíncrono. Generalmente, se marca como 'False Path' 
# para que Vivado no intente chequear su temporización con el reloj síncrono.
set_false_path -from [get_ports arst_n]