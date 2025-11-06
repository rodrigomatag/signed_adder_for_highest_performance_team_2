#########################################################################
# XDC Constraints for ripple_adder (Combinational Logic Timing)
#########################################################################

# 1. Definición del Reloj Virtual
# El ripple_adder es un módulo combinacional, por lo que necesita un 
# 'reloj virtual' para realizar el análisis de temporización (Timing Analysis).
# Se define un periodo de 10.0 ns (equivalente a una frecuencia de 100 MHz).
# Esto establece el objetivo de rendimiento.
# Se usa un puerto dummy ([get_ports a]) ya que no hay un pin de reloj real.

create_clock -name virtual_clk -period 10.000 [get_ports a]

# 2. Restricciones de Retardo de Entrada (Input Delay)
# Indica que los datos de entrada (a, b, cin) deben estar disponibles al inicio 
# del ciclo de reloj virtual. El valor '0.000' asegura que el camino crítico 
# se mida desde las entradas hasta las salidas sin márgenes adicionales.

set_input_delay -clock virtual_clk -max 0.000 [get_ports {a b cin}]

# 3. Restricciones de Retardo de Salida (Output Delay)
# Indica que las salidas (s, overflow) deben estabilizarse antes del final 
# del ciclo de reloj virtual. El valor '0.000' obliga a que el retardo total 
# (T_prop_max) del circuito sea menor o igual al periodo del reloj (10.0 ns).

set_output_delay -clock virtual_clk -max 0.000 [get_ports {s overflow}]

#########################################################################